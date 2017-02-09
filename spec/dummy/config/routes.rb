Rails.application.routes.draw do

  mount SearchClient::Engine => "/search_client"
end
