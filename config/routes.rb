Rails.application.routes.draw do
  post '/register' => 'users#create'
end
