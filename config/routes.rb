Testupload::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'
  root :to => 'uptest#index'
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'


  match 'uptest'=>'uptest#index'
  match 'uptest_upload'=>'uptest#upload'
  match 'uptest_download'=>'uptest#download'
  match 'uptest_delete'=>'uptest#delete'
  match 'uptest_downerr'=>'uptest#downerr'
  match '/editall'=>'uptest#editall'
  match '/saveall'=>'uptest#saveall'
  post 'set_public' =>'uptest#set_public'
   
  match 'uptest_rename'=>'uptest#rename'
  match 'uptest_upinfo'=>'uptest#upinfo'
  match 'file_:b64'=>'uptest#upinfo'
  match 'down_:b64'=>'uptest#download'
  
  match '/user/loginpage'=>'user#loginpage'
  post '/user/login'=>'user#login'
  match '/user/logout'=>'user#logout'
  post '/user/register'=>'user#register'
  match '/user/registerpage'=>'user#registerpage'
  match '/user/change_password_page'=>'user#change_password_page'
  post '/user/change_password'=>'user#change_password'
  match '/user/'=>'user#user_info'
  match '/user/edit_info'=>'user#edit_info_page'
  post '/user/edit_info_save'=>'user#edit_info_save'
  match '/user/notification_read' =>'user#notification_read'
  
  match '/admin/loginpage'=>'admin#loginpage'
  post '/admin/login'=>'admin#login'
  match '/admin/logout'=>'admin#logout'
  match '/admin/deleteall'=>'admin#deleteall'
  match '/admin/'=>'admin#index'
  post '/admin/reset_password'=>'admin#reset_password'
  
  match '/admin/notification'=>'admin#notification'
  match '/admin/newnotification'=>'admin#newnotification'
  post '/admin/newnotification_save'=>'admin#newnotification_save'
  match '/admin/deletenotification'=>'admin#deletenotification'
  post '/admin/deletenotification_user'=>'admin#deletenotification_user'
  
  
  match '/postthread'=>'postthread#index'
  post'/postthread/new_thread_save' => 'postthread#new_thread_save'
  match'/postthread/view' => 'postthread#view'
  match'/postthread/reply_save' => 'postthread#reply_save'
  match'/postthread/edit' => 'postthread#edit'
  post'/postthread/edit_save' => 'postthread#edit_save'
  match'/postthread/edit_reply' => 'postthread#edit_reply'
  post'/postthread/edit_reply_save' => 'postthread#edit_reply_save'
  
  post'/postthread/delete' => 'postthread#delete'
  match'/postthread/delete_reply' => 'postthread#delete_reply'
  
end
