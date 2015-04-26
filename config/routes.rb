Rails.application.routes.draw do
  resources :items, except: [:new, :edit]
  resources :catagories, except: [:new, :edit]
  resources :reviews, only: [:index, :update]

  post '/subscriptions/plan' => 'subscriptions#update_plan'

  post '/subscriptions/data' => 'subscriptions#update_customer'
  delete '/subscriptions/data' => 'subscriptions#delete_customer'

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

  mount StripeEvent::Engine, at: '/stripe-hook'
end
