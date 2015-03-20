CachoComoEs::Application.routes.draw do
  

  devise_for :users
  resources  :games do
  	get 'buildabag', on: :collection
  end
  resources  :players
 	resources  :turns
  resources  :hands

  root :to => "games#new"

    
  
end
