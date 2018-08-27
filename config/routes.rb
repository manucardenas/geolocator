Rails.application.routes.draw do
  resources :places, only: [:index, :show, :create, :destroy]
  root 'places#index'
end
