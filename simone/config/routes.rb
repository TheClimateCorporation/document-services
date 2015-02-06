Rails.application.routes.draw do
  OkComputer::Engine.routes.draw do
    match '/' => 'ok_computer#index', via: [:get, :options]
  end

  resources :id_reservations, only: [:create]
  put '/id_reservations/:document_id', to: 'id_reservations#disable'

  resources :documents, only: [:create]
  resources :document_links, only: [:create]
end
