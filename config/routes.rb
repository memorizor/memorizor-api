Rails.application.routes.draw do
  resources :items, except: [:new, :edit]

  get '/reviews' => 'reviews#index'

  post '/register' => 'users#create'

  post '/authenticate' => 'users#authenticate'
  get '/logout' => 'users#logout'

  get '/user' => 'users#get'
  patch '/user' => 'users#update'

  post '/verify' => 'verifies#create'
  get '/verify' => 'verifies#index'

  post '/reset' => 'reset_password#create'
  post '/reset/valid' => 'reset_password#valid'
  get '/reset' => 'reset_password#index'
end
