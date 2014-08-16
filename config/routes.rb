Rails.application.routes.draw do
  post '/register' => 'users#create'
  post '/authenticate' => 'users#authenticate'
  get '/user' => 'users#get'
  patch '/user' => 'users#update'
  post '/verify' => 'verifies#create'
  get '/verify' => 'verifies#show'
end
