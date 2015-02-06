Rails.application.routes.draw do

  resources :templates, only: [:index, :show, :new, :create] do
    resources :template_versions, as: 'versions', only: [:new, :create, :show], param: :version, path: 'v' do
      resources :template_permission_changes, as: 'permissions', only: [:create],
                path: 'permission_changes'
      resource :sample_document, only: [:create]
    end
  end

  resources :template_schemas do
    member do
      get :clone
    end
  end

  post '/generate' => 'document_generation#generate', defaults: {format: :json}

  OkComputer::Engine.routes.draw do
    match '/' => 'ok_computer#index', via: [:get, :options]
  end

  resources :swagger, only: :index
  resources :swagger_resources, only: :show, path: '/swagger/resources'

  root to: 'templates#index'
end
