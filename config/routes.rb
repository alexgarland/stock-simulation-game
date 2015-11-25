Rails.application.routes.draw do
  root 'welcome#home'
  get 'signup' => 'users#new'
  resource :users
end
