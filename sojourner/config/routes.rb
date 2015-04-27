# The Climate Corporation licenses this file to you under under the Apache
# License, Version 2.0 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# See the NOTICE file distributed with this work for additional information
# regarding copyright ownership.  Unless required by applicable law or agreed
# to in writing, software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied.  See the License for the specific language governing permissions
# and limitations under the License.
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

  root to: 'templates#index'
end
