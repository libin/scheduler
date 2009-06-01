ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resources :events
  
  map.monthly "monthly", :controller => "events", :action => "index"
  map.weekly "weekly", :controller => "events", :action => "weekly"
  map.weekly_all "weekly_all", :controller => "events", :action => "weekly_all"
  map.list "list", :controller => "events", :action => "list"
  
  map.root :weekly

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
