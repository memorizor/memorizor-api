Rails.application.routes.draw do
  post '/register' => 'users#create'
  post '/authenticate' => 'users#authenticate'
  post '/user' => 'users#get'
  post '/verify' => 'verifies#create'
  get '/verify/:verification_token' => 'verifies#show'
end
