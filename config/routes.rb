Rails.application.routes.draw do

  root 'welcome#home'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  get 'quotes' => 'quotes#new'
  post 'quotes' => 'quotes#get_quote'
  get 'transact' => 'transact#new'
  post 'transact' => 'transact#perform'
  resource :users

end
