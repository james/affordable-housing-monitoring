class DwellingsController < ApplicationController
  before_action :find_development

  def index
    @dwellings = @development.dwellings
    @dwelling = Dwelling.new
  end

  def create
    @dwelling = Dwelling.new(dwelling_params.merge(development: @development))
    if @dwelling.save
      flash[:notice] = 'Dwelling successfully added'
      redirect_to development_dwellings_path(@development)
    else
      @dwellings = @development.dwellings
      render action: :index
    end
  end

  private

  def find_development
    @development = Development.find(params[:development_id])
  end

  def dwelling_params
    params.require(:dwelling).permit(:tenure, :habitable_rooms, :bedrooms)
  end
end
