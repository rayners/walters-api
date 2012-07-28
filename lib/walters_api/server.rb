require 'sinatra/base'
require 'json'
module WaltersApi
  class Server < Sinatra::Base

    get %r{/places/([\w-]+)(?:\.json)?} do
      content_type :json
      Parser.place(params[:captures].first).to_json
    end
    get %r{/places(?:\.json)?} do
      content_type :json
      Parser.places.to_json
    end
    get %r{/mediums/([\w-]+)(?:\.json)?} do
      content_type :json
      Parser.medium(params[:captures].first, params[:page]).to_json
    end
    get %r{/mediums(?:\.json)?} do
      content_type :json
      Parser.mediums.to_json
    end
    get %r{/creators(?:/([a-z]))?(?:\.json)$?} do
      content_type :json
      Parser.creators(params[:captures] && params[:captures].first).to_json
    end
    get %r{/creators/([\w-]+)(?:\.json)$?} do
      content_type :json
      Parser.creator(params[:captures].first, params[:page]).to_json
    end
    get %r{/tags(?:/([a-z]))?(?:\.json)?$} do
      content_type :json
      Parser.tags(params[:captures].try(:first)).to_json
    end
    get %r{/tags/([\w-]+)(?:.json)?$} do
      content_type :json
      Parser.tag(params[:captures].first).to_json
    end
    get %r{/locations/([\w-]+)(?:\.json)?$} do
      content_type :json
      id = params[:captures].first
      location = Parser.locations.find { |l| l[:id] == id }
      Parser.location(id,params[:page]).merge(location).to_json
    end
    get '/locations.?:format?' do
      content_type :json
      Parser.locations.to_json
    end
    get '/detail/:id.?:format?' do
      content_type :json
      Parser.get(params[:id]).to_json
    end
  end
end
