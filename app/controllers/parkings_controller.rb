class ParkingsController < ApplicationController
  before_action :validate_plate
  before_action :load_all_parkings_of_plate, only: :show
  before_action :load_last_park_for_plate, only: [:pay, :out]

  def show
  end

  def park
    parking = Parking.new(plate: params[:plate])

    if parking.save
      render json: { message: "created" }, status: :created
    else
      render json: { error: "invalid transition, #{parking.errors.full_messages}" }, status: :ok
    end
  end

  def pay
    begin
      @parking.pay!      
    rescue => e
      render json: { error: "invalid transition, #{e}" }, status: :ok
    else
      render json: { message: "paid" }, status: :accepted
    end
  end

  def out
    begin
      @parking.out!
    rescue => e
      render json: { error: "invalid transition, #{e}" }, status: :ok
    else
      render json: { message: "out" }, status: :accepted
    end
  end

  private

  def validate_plate
    rescue_invalid_plate unless /^[a-zA-Z]{3}-[0-9]{4}$/.match?(params[:plate])
  end

  def load_all_parkings_of_plate
    @parkings = Parking.where(plate: params[:plate])
    rescue_plate_not_found if @parkings.empty?
  end

  def load_last_park_for_plate
    @parking = Parking.where(plate: params[:plate]).last
    rescue_plate_not_found unless @parking.present?
  end

  def rescue_invalid_plate
    render json: { error: 'invalid plate' }, status: :ok
  end

  def rescue_plate_not_found
    render json: { error: 'plate not found' }, status: :ok
  end
end
