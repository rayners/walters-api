
require './walters_parser'

class WaltersApi < Sinatra::Base

  get %r{/creators(?:/([a-z]))?(?:\.json)?} do
    content_type :json
    WaltersParser.creators(params[:captures].try(:first)).to_json
  end
  get %r{/tag/([\w-]+)(?:.json)?} do
    content_type :json
    WaltersParser.tag(params[:captures].first).to_json
  end
  get %r{/tags(?:/([a-z]))?(?:\.json)?} do
    content_type :json
    WaltersParser.tags(params[:captures].try(:first)).to_json
  end
  get '/location/:id.json' do
    content_type :json
    WaltersParser.location(params[:id]).to_json
  end
  get '/location/:id' do
    content_type :json
    WaltersParser.location(params[:id]).to_json
  end
  get '/locations.?:format?' do
    content_type :json
    WaltersParser.locations.to_json
  end
  get '/detail/:id.?:format?' do
    content_type :json
    WaltersParser.get(params[:id]).to_json
  end

end
