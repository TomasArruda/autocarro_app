Rails.application.routes.draw do
  root to: "buses#index"
  resources :bus_stops
  resources :trips
  resources :buses

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
