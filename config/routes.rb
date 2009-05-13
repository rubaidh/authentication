ActionController::Routing::Routes.draw do |map|

  map.resource :user
  map.resource :password, :only => [:new, :create, :edit, :update]
  map.resource :activation, :only => [:new, :create]
  map.resource :session

  map.namespace :admin do |admin|
    admin.resources :users, :member     => { :activate => :put, :suspend => :put, :reset_password => :put, :administrator => :put },
                            :collection => { :inactive => :get }
  end

  map.login   "/login",  :controller => 'sessions', :action => 'new'
  map.logout  "/logout", :controller => 'sessions', :action => 'destroy'
  map.signup  "/signup", :controller => 'users',     :action => 'new'

  map.activate "/login/activate/:activation_code", :controller => "logins", :action => "activate", :activation_code => nil

end
