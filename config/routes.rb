ActionController::Routing::Routes.draw do |map|
  
  # resource mappings
  map.resources :friends

  # root mapping
  map.root :controller => "friends"
  
end
