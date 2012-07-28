require 'uri'
require 'open-uri'
require 'net/http'
require 'ostruct'
require 'nokogiri'

class WaltersParser
  def self._list(type,params={})
    url = "http://art.thewalters.org/ajax/browse/get-type/?type=#{type}"
    if params
      url += params.map { |(k,v)| "&#{k}=#{v}" }.join('')
    end
    Nokogiri::HTML(open(url))
  end
  def self._medium(name,page=1)
    Nokogiri::HTML(open("http://art.thewalters.org/browse/medium/#{name}/?page=#{page}"))
  end
  def self.medium(name,page=1)
    doc = _medium(name,page)
    pieces = doc.search('#object_listing a').map do |p|
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
      piece.thumbnail = p.search('img').first.attr('src')
      piece.marshal_dump
    end
    pages = doc.search('span.position.end').first.text
    { pieces: pieces, page: page, pages: pages }
  end
  def self._mediums
    _list('medium')
  end
  def self.mediums
    doc = _mediums
    doc.search('a').map do |m|
      medium = OpenStruct.new
      medium.id = m.attr('href').gsub(%r{^.*/medium/}, '').gsub(%r{/$}, '')
      medium.name = m.search('h2').first.text
      medium.thumbnail = m.search('img').first.attr('src')
      medium.marshal_dump
    end
  end
  def self._creators(letter)
    _list('creator', letter: letter)
  end
  def self._creator_from_listing(c)
    creator = OpenStruct.new
    href = c.attr('href')
    creator.id = href.gsub(/^.*\/creator\//, '').gsub(/\/$/, '')
    creator.name = c.search('h2').first.text
    creator.thumbnails = c.search('span.image img').map { |i| i.attr('src') }
    creator.marshal_dump
  end
  def self.creators(letter=nil)
    if letter
      doc = _creators(letter)
      doc.search('a').map { |c| _creator_from_listing(c) }
    else
      ('a'..'z').map do |l|
        doc = _creators(l)
        doc.search('a').map { |c| _creator_from_listing(c) }
      end.flatten
    end
  end
  def self._tag(name)
    Nokogiri::HTML(open("http://art.thewalters.org/browse/tag/#{name}/"))
  end
  def self.tag(name)
    doc = _tag(name)
    doc.search('#object_listing a').map do |p|
      piece = OpenStruct.new
      href = p.attr('href')
      href.match(%r{^http://art.thewalters.org/detail/(\d+)/(.*?)/$}) do |m|
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
      piece.thumbnail = p.search('img').first.attr('src')
      piece.marshal_dump
    end
  end
  def self._tags(letter)
    _list('tags', letter: letter)
  end
  def self.tags(letter=nil)
    if letter
      doc = _tags(letter)
      doc.search('a').map do |t|
        tag = OpenStruct.new
        tag.id = t.search('h2').first.children.first.text
        tag.count = t.search('span.count').first.text
        tag.marshal_dump
      end
    else
      ('a'..'z').map do |l|
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
  def self._location(id)
    Nokogiri::HTML(open("http://art.thewalters.org/browse/location/#{id}/"))
  end
  def self.location(id)
    doc = _location(id)
    doc.search('#object_listing a').map do |p|
      piece = OpenStruct.new
      href = p.attr('href')
      href.match(%r{^http://art.thewalters.org/detail/(\d+)/(.*?)/$}) do |m|
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
      piece.thumbnail = p.search('img').first.attr('src')
      piece.marshal_dump
    end
  end
  def self._locations
    _list('location')
  end
  def self.locations
    doc = _locations
    doc.search('a').map do |l|
      loc = OpenStruct.new
      href = l.attr('href')
      loc.id = href.gsub(/^.*location\//, '').gsub(/\/$/, '')
      loc.name = l.search('h2').first.text
      loc.location = l.search('p').first.text
      loc.thumbnail = l.search('img').first.attr('src')
      loc.marshal_dump
    end
  end
  def self._get(id)
    uri = URI("http://art.thewalters.org/detail/#{id}/")
    Nokogiri::HTML(open("http://art.thewalters.org/detail/#{id}"))
  end
  def self.get(id)
    doc = _get(id)
    # <meta property="og:title" content="Inscribed Pound Weight" />
    obj = OpenStruct.new
    obj.title = doc.search('h1 a').first.text
    doc.search('div.scrollbar').each do |section|
      title = section.search('span').first.text
      if title == 'Description'
        obj.description = section.children.last.text.strip
      end
    end
    obj.marshal_dump
  end
end

