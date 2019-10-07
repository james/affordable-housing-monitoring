class DevelopmentsController < ApplicationController
  def index
    @developments = Development.all
  end

  def new
    @development = Development.new
  end

  def create
    @development = Development.create!(development_params)
    flash[:notice] = 'Development successfully created'
    redirect_to action: :index
  end

  def edit
    @development = Development.find(params[:id])
  end

  def update
    @development = Development.find(params[:id])
    @development.update(development_params)
    flash[:notice] = 'Development successfully saved'
    redirect_to action: :index
  end

  private

  def development_params
    params.require(:development).permit(:application_number, :site_address, :proposal)
  end
end
