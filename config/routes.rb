Test5::Application.routes.draw do

  resources :search_histories


  match '/apk', :to => redirect('/weicai.apk')
  
  
  resources :ships
  resources :bills


  resources :order_items
  resources :settings


  resources :orders do
    member do
      get 'submit'
      get 'continue_buy'
      get 'print_order'
      get 'print_ship'
      get 'loading'
      get 'sign'
      get 'done'
      get 'cancel'
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
      get 'sortable_market'
      post 'update_sn'
      post "update_market"
    end
    member do
      get 'to_up'
      get 'to_down'
      get 'to_file'
      put 'upload_file'
      delete 'delete_attachment'
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
          get 'types'
        end
        member do 
          post 'avatar'
        end
      end
      resources :users do
        collection do
          post 'sign_up'
          post 'get_sign_up_validate_code'
          post 'send_validate_code'
          post 'sign_in'
          get 'has_validate_code'
          post 'update_password'
          post 'change_password'
          post 'update_baidu_user_id'
        end
      end
      resources :bills
      resources :orders do
        collection do
          post 'list'
          post 'auto_make_order'
        end
        member do
          get 'submit'
          get 'continue_buy'
          get 'sign'
          get 'cancel'
        end
      end
      resources :order_items
      resources :payments do
        collection do
          post 'list'
        end
      end
      resources :search_histories do
        collection do
          post 'list'
        end
      end
      
    end


    
  end
  

  
  root :to => 'products#index'
end


