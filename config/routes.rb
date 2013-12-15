Test5::Application.routes.draw do
  
  resources :registrations do
    collection do
      get 'sign_up'
    end
    member do 
      get 'validate_code'
      post 'validate'
      get 'password_new'
      post 'password'
    end
  end
  
  resources :sessions do
    collection do
      delete 'sign_out'
    end
  end
  
  resources :users
  resources :prices
  resources :products

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1 do#, constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :products
    end
  end
  
  root :to => 'products#index'
end
