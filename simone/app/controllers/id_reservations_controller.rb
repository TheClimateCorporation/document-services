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
