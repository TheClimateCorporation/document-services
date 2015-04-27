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
class IdReservationsController < ApplicationController
  before_action :load_reservation, only: [:disable]

  # POST /id_reservations
  def create
    reservation = IdReservation.create
    render json: reservation, status: :ok
  end

  # PUT /id_reservations/:document_id
  def disable
    if @reservation.disable
      render json: @reservation, status: :ok
    else
      render json: { errors: reservation.errors }, status: :bad_request
    end
  end

  private

  def load_reservation
    @reservation = IdReservation.where(document_id: params[:document_id]).first

    if @reservation.nil?
      render json: { message: "I'm so sorry... we don't seem to have that reservation.",
                     errors: ["No IdReservation found for for document_id: #{params[:document_id]}"]
                    }, status: :bad_request
    end
  end
end
