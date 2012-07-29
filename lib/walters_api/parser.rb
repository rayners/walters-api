require 'uri'
require 'open-uri'
require 'net/http'
require 'ostruct'
require 'nokogiri'

$cache = {}

module WaltersApi
  class Parser
    def self._list(type,params={})
      url = "http://art.thewalters.org/ajax/browse/get-type/?type=#{type}"
      if params
        url += params.map { |(k,v)| "&#{k}=#{v}" }.join('')
    end
      Nokogiri::HTML(open(url))
    end
    def self._piece_from_listing(p)
      piece = OpenStruct.new
      p.attr('href').match(%r{^http://art.thewalters.org/detail/(\d+)/(.*?)/$}) do |m|
        piece.id = m[1]
        piece.id_string = m[2]
      end
      p.search('tr').each do |r|
        label = r.search('td.label').first.text
        if label != 'Tags'
          piece.send("#{label.downcase}=", r.search('td').first.text)
        else
          tags = r.search('td').first.search('span').map { |s| s.text }
          piece.tags = tags
        end
      end
      img = p.search('img').first
      piece.thumbnail = {
        url:    img.attr('src'),
        width:  img.attr('width'),
        height: img.attr('height')
      }
      piece.marshal_dump
    end
    def self._paginated_pieces(source)
      pieces = source.search('#object_listing a').map { |p| _piece_from_listing(p)}
      pages = source.search('span.position.end').first.text
      page = source.search('span.digit').first.text
      page = 1 if page == ''
      { pieces: pieces, page: page, pages: pages }
    end
    def self._date(start_date,end_date,page=1)
    end
    def self.date(start_date,end_date,page=1)
      doc = _date(start_date,end_date,page)
      pieces = doc.search('#object_listing a').map { |p| _piece_from_listing(p)}
      pages = doc.search('span.position.end').first.text
      { pieces: pieces, page: page, pages: pages }
    end
    def self._place(name,page=1)
      Nokogiri::HTML(open("http://art.thewalters.org/browse/place/#{name}/?page=#{page}"))
    end
    def self.place(name,page=1)
      _paginated_pieces(_place(name,page))
    end
    def self._places
      _list('places')
    end
    def self.places
      if $cache['places']
        return $cache['places']
      end
      doc = _places
      places = doc.search('a').map do |p|
        place = OpenStruct.new
        place.id = p.attr('href').gsub(%r{^.*/place/}, '').gsub(%r{/$}, '')
        place.name = p.search('h2').first.text
        place.thumbnails = p.search('img').map { |i| { url: i.attr('src') } }
        place.marshal_dump
      end
      $cache['places'] = { places: places }
    end
    def self._medium(name,page=1)
      Nokogiri::HTML(open("http://art.thewalters.org/browse/medium/#{name}/?page=#{page}"))
    end
    def self.medium(name,page=1)
      _paginated_pieces(_medium(name,page))
    end
    def self._mediums
      _list('medium')
    end
    def self.mediums
      if $cache['mediums']
        return $cache['mediums']
      end
      doc = _mediums
      $cache['mediums'] = doc.search('a').map do |m|
        medium = OpenStruct.new
        medium.id = m.attr('href').gsub(%r{^.*/medium/}, '').gsub(%r{/$}, '')
        medium.name = m.search('h2').first.text
        medium.thumbnail = { url: m.search('img').first.attr('src') }
        medium.marshal_dump
      end
    end
    def self._creator(name,page=1)
      Nokogiri::HTML(open("http://art.thewalters.org/browse/creator/#{name}/?page=#{page}"))
    end
    def self.creator(name,page=1)
      _paginated_pieces(_creator(name,page))
    end
    def self._creators(letter)
      _list('creator', letter: letter)
    end
    def self._creator_from_listing(c)
      creator = OpenStruct.new
      href = c.attr('href')
      creator.id = href.gsub(/^.*\/creator\//, '').gsub(/\/$/, '')
      creator.name = c.search('h2').first.text
      creator.thumbnails = c.search('span.image img').map { |i| { url: i.attr('src') } }
      creator.marshal_dump
    end
    def self.creators(letter=nil)
      if letter
        if $cache["creators_#{letter}"]
          return $cache["creators_#{letter}"]
        end
        doc = _creators(letter)
        $cache["creators_#{letter}"] = doc.search('a').map { |c| _creator_from_listing(c) }
      else
        if $cache['creators']
          return $cache['creators']
        end
        $cache['creators'] = ('a'..'z').map do |l|
          doc = _creators(l)
          doc.search('a').map { |c| _creator_from_listing(c) }
        end.flatten
      end
    end
    def self._tag(name,page=1)
      Nokogiri::HTML(open("http://art.thewalters.org/browse/tag/#{name}/?page=#{page}"))
    end
    def self.tag(name,page=1)
      _paginated_pieces(_tag(name,page))
    end
    def self._tags(letter)
      _list('tags', letter: letter)
    end
    def self.tags(letter=nil)
      if letter
        if $cache["tags_#{letter}"]
          return $cache["tags_#{letter}"]
        end
        doc = _tags(letter)
        $cache["tags_#{letter}"] = doc.search('a').map do |t|
          tag = OpenStruct.new
          tag.id = t.search('h2').first.children.first.text
          tag.count = t.search('span.count').first.text
          tag.marshal_dump
        end
      else
        if $cache['tags']
          return $cache['tags']
        end
        $cache['tags'] = ('a'..'z').map do |l|
          doc = _tags(l)
          doc.search('a').map do |t|
            tag = OpenStruct.new
            tag.id = t.search('h2').first.children.first.text
            tag.count = t.search('span.count').first.text
            tag.marshal_dump
          end
        end.flatten
      end
    end
    def self._location(id,page=1)
      Nokogiri::HTML(open("http://art.thewalters.org/browse/location/#{id}/?page=#{page}"))
    end
    def self.location(id,page=1)
      if $cache["locations_#{id}_#{page}"]
        return $cache["locations_#{id}_#{page}"]
      end
      $cache["locations_#{id}_#{page}"] = _paginated_pieces(_location(id,page))
    end
    def self._locations
      _list('location')
    end
    def self.locations
      if $cache['locations']
        return $cache['locations']
      end
      doc = _locations
      $cache['locations'] = doc.search('a').map do |l|
        loc = OpenStruct.new
        href = l.attr('href')
        loc.id = href.gsub(/^.*location\//, '').gsub(/\/$/, '')
        loc.name = l.search('img').first.attr('alt')
        loc.location = l.search('p').first.text.gsub(/^Museum Location:/, '').strip
        loc.thumbnail = {
          url: l.search('img').first.attr('src')
        }
        loc.marshal_dump
      end
    end
    def self._get(id)
      uri = URI("http://art.thewalters.org/detail/#{id}/")
      Nokogiri::HTML(open("http://art.thewalters.org/detail/#{id}"))
    end
    def self.get(id)
      if $cache["pieces_#{id}"]
        return $cache["pieces_#{id}"]
      end
      doc = _get(id)
      obj = OpenStruct.new
      obj.title = doc.search('h1 a').first.text
      doc.search('article.pane').each do |pane|
        title = pane.search('span').first.text
        if title != 'Conservation'
          obj.send("#{title.downcase}=", pane.search('div.scrollbar').first.children.last.text.strip)
        else
          obj.conservation = pane.search('tbody tr').map do |r|
            date = r.search('td.date').first.text
            description = r.search('td.description').first.text
            narrative   = r.search('td.narrative').first.text
            { date: date, description: description, narrative: narrative }
          end
        end
      end
      obj.image = doc.search('a.button.download').first.attr('href')
      doc.search('div.column').each do |column|
        title = column.search('h6').first.text
        if title == 'Creator'
          obj.creators = column.search('li a').map do |c|
            {
              id: c.attr('href').gsub(%r{^.*/creator/}, '').gsub(%r{/$}, ''),
              name: c.text
            }
          end
        elsif title == 'Medium'
          obj.medium = {
            id: column.search('a').first.attr('href').gsub(%r{^.*/medium/([\w-]+)/$}, '\1').strip,
            details: column.search('br').first.previous_sibling.text.strip
          }
        elsif title == 'Geographies'
          obj.geographies = column.search('li').map do |l|
            a = l.search('a').first
            {
              id: a.attr('href').gsub(%r{^.*/place/([\w-]+)/$}, '\1').strip,
              details: a.text.strip,
              type: a.next_sibling.text.strip
            }
          end
        elsif title == 'Location Within Museum'
          a = column.search('a').first
          name = a.text
          obj.location = {
            id: a.attr('href').gsub(%r{^.*/location/}, '').gsub(%r{/$}, '').strip,
            name: name.gsub(/^.*:([^:]+)$/, '\1').strip,
            location: name.gsub(/:[^:]+$/, '').strip
          }
        else
          obj.send("#{title.downcase}=", column.children.last.text.strip)
        end
      end
      obj.tags = doc.search('#tag_container a').map { |t| t.text }
      obj.related = doc.search('aside.related a').map { |r| _piece_from_listing(r) }
      $cache["pieces_#{id}"] = obj.marshal_dump
    end
  end
end
