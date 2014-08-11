Rails.application.routes.draw do
  post '/register' => 'users#create'
  post '/authenticate' => 'users#authenticate'
  post '/user' => 'users#get'
end
