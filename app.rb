
require './walters_parser'

class WaltersApi < Sinatra::Base

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
