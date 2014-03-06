Test5::Application.routes.draw do

  match '/apk', :to => redirect('/weicai.apk')
  
  
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
      post 'recharge'
    end
  end
  resources :prices
  resources :products do
    collection do
      get 'search'
      get 'export'
      get 'sortable'
      post 'update_sn'
      get 'print'
    end
    member do
      get 'to_up'
      get 'to_down'
      get 'to_file'
    end
  end
    

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :products do
        collection do
          post 'list'
        end
      end
      resources :users do
        collection do
          post 'sign_up'
          post 'validate'
          post 'sign_in'
        end
      end
      resources :bills
      resources :orders do
        collection do
          post 'list'
        end
      end
      resources :order_items
    end
    
    namespace :v2 do
      resources :products do
        collection do
          post 'list'
        end
      end
      resources :users do
        collection do
          post 'sign_up'
          post 'get_validate_code'
          post 'sign_in'
          get 'has_validate_code'
        end
      end
      resources :bills
      resources :orders do
        collection do
          post 'list'
        end
      end
      resources :order_items
      resources :payments do
        collection do
          post 'list'
        end
      end
      
    end


    
  end
  

  
  root :to => 'products#index'
end


