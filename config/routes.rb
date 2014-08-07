Rails.application.routes.draw do
  post '/register' => 'users#create'
  post '/authenticate' => 'users#authenticate'
end
