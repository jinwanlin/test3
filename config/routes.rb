Test5::Application.routes.draw do

  resources :companies


  resources :search_histories

  # match '/apk', :to => redirect('/weicai_1.1.apk')
  # match '/weicai.apk', :to => redirect('/weicai_1.1.apk')
  
  match '/apk' => 'api::versions#apk'
  match '/weicai.apk' => 'api::versions#apk'
  
  
  resources :ships
  

  resources :payments do
    collection do
      post 'list'
    end
  end


  resources :order_items do
    member do
      get "edit_amount"
      post "save_amount"
    end
  end
  resources :settings


  resources :orders do
    collection do
      get 'print_order'
      get 'auto_make_order'
    end
    member do
      get 'submit'
      get 'continue_buy'
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
      get 'list'
      get 'search'
      get 'export'
      get 'sortable'
      get 'sortable_market'
      get 'sortable_print'
      get 'sortable_series'
      post 'update_sn'
      post "update_market"
      post "update_series"
      get 'print_dm'
      get 'user_buy_list_print'
    end
    member do
      get 'to_up'
      get 'to_down'
      get 'to_file'
      put 'upload_file'
      put 'update_product'
      delete 'delete_attachment'
      get 'change_price'
      get 'change_all_price'
      get 'change_price_cq'
    end
  end
    
    
    
    
    
    
    
    
    
    

  namespace :api, defaults: {format: 'json'} do
    resources :versions do
      collection do
        get 'last_version'
      end
    end
    
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
  

  
  root :to => 'sessions#new'
end


