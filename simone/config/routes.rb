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
  OkComputer::Engine.routes.draw do
    match '/' => 'ok_computer#index', via: [:get, :options]
  end

  resources :id_reservations, only: [:create]
  put '/id_reservations/:document_id', to: 'id_reservations#disable'

  resources :documents, only: [:create]
  resources :document_links, only: [:create]
end
