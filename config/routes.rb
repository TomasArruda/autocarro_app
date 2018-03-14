Rails.application.routes.draw do
  devise_for :users
  root to: "gps#index"
  
  authenticated :user do
    scope '/admin' do
      resources :bus_stops
      resources :trips
      resources :buses
    end

    resources :gps, only: [:index]
    
    post '/gps/find_bus/', to: 'gps#find_bus', as: "find_bus"
  end
end
