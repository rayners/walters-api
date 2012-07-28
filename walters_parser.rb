require 'uri'
require 'open-uri'
require 'net/http'
require 'ostruct'
require 'nokogiri'

class WaltersParser
  def self._get(id)
    uri = URI("http://art.thewalters.org/detail/#{id}/")
    Nokogiri::HTML(open("http://art.thewalters.org/detail/#{id}"))
  end
  def self.get(id)
    doc = _get(id)
    # <meta property="og:title" content="Inscribed Pound Weight" />
    obj = OpenStruct.new
    obj.title = doc.search('h1 a').first.text
    obj.marshal_dump
  end
end

