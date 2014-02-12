Test5::Application.routes.draw do
  
  resources :ships
  resources :bills


  resources :order_items
  resources :settings


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
      get 'export'
    end
    member do
      get 'to_up'
      get 'to_down'
      get 'to_file'
    end
  end
    

  namespace :api, defaults: {format: 'json'} do
    scope module: :v1 do#, constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :products
      resources :users do
        collection do
          post 'sign_up'
          post 'validate'
          post 'sign_in'
          post 'send_validate_code'
        end
      end
      resources :bills
      resources :orders
      resources :order_items
    end
  end
  
  root :to => 'products#index'
end


