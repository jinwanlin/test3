Test5::Application.routes.draw do
  
  resources :ships


  resources :order_items


  resources :orders do
    member do
      put 'submit'
      put 'cancel'
      put 'ship'
      put 'done'
      get 'print'
    end
  end


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
  
  resources :users do
    member do
      get 'active'
      get 'frost'
    end
  end
  resources :prices
  resources :products do
    collection do
      get 'search'
    end
  end
    

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1 do#, constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :products
    end
  end
  
  root :to => 'products#index'
end
