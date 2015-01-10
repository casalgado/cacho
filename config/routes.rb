CachoComoEs::Application.routes.draw do
  

  devise_for :users
  resources :games
  resources :players
 	resources :turns
  resources :hands

  root :to => "games#new"

    
  
end
