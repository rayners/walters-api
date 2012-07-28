require 'uri'
require 'open-uri'
require 'net/http'
require 'ostruct'
require 'nokogiri'

class WaltersParser
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
    Nokogiri::HTML(open("http://art.thewalters.org/browse/?type=tags&letter=#{letter}"))
  end
  def self.tags(letter=nil)
    if letter
      doc = _tags(letter)
      doc.search('#browse_listing a').map do |t|
        tag = OpenStruct.new
        tag.id = t.search('h2').first.children.first.text
        tag.count = t.search('span.count').first.text
        tag.marshal_dump
      end
    else
      ('a'..'z').map do |l|
        doc = _tags(l)
        doc.search('#browse_listing a').map do |t|
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
    Nokogiri::HTML(open("http://art.thewalters.org/browse/?type=location"))
  end
  def self.locations
    doc = _locations
    doc.search('#browse_listing a').map do |l|
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

