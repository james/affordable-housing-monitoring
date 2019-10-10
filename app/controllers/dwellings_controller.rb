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

  def edit
    @dwelling = @development.dwellings.find(params[:id])
  end

  def update
    @dwelling = @development.dwellings.find(params[:id])
    if @dwelling.update(dwelling_params)
      flash[:notice] = 'Dwelling successfully saved'
      redirect_to development_dwellings_path(@development)
    else
      render action: :edit
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
