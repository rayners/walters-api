
require './walters_parser'

class WaltersApi < Sinatra::Base

  get '/locations.?:format?' do
    content_type :json
    WaltersParser.locations.to_json
  end
  get '/detail/:id.?:format?' do
    content_type :json
    WaltersParser.get(params[:id]).to_json
  end

end
