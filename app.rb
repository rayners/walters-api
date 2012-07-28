
require './walters_parser'

class WaltersApi < Sinatra::Base

  get '/detail/:id' do
    content_type :json
    WaltersParser.get(params[:id]).to_json
  end

end
