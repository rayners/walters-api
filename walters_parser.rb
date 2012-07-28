require 'uri'
require 'open-uri'
require 'net/http'
require 'ostruct'
require 'nokogiri'

class WaltersParser
  def self._locations
    Nokogiri::HTML(open("http://art.thewalters.org/browse/?type=location"))
  end
  def self.locations
    doc = _locations
    museum_locations = []
    doc.search('figure.museum_location').map do |l|
      loc = OpenStruct.new
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

