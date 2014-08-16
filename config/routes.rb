Rails.application.routes.draw do
  post '/register' => 'users#create'

  post '/authenticate' => 'users#authenticate'
  get '/logout' => 'users#logout'

  get '/user' => 'users#get'
  patch '/user' => 'users#update'
  
  post '/verify' => 'verifies#create'
  get '/verify' => 'verifies#index'
end
