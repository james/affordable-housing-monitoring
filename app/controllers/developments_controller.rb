class DevelopmentsController < ApplicationController
  def index
    @developments = Development.all
  end

  def new
    @development = Development.new
  end

  def create
    @development = Development.new(development_params)
    if @development.save
      flash[:notice] = 'Development successfully created'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def show
    @development = Development.find(params[:id])
  end

  def edit
    @development = Development.find(params[:id])
  end

  def update
    @development = Development.find(params[:id])
    if @development.update(development_params)
      flash[:notice] = 'Development successfully saved'
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  def agree_confirmation
    @development = Development.find(params[:id])
  end

  def agree
    @development = Development.find(params[:id])
    @development.agree!
    flash[:notice] = 'Development marked as agreed'
    redirect_to development_path(@development)
  end

  def start_confirmation
    @development = Development.find(params[:id])
  end

  def start
    @development = Development.find(params[:id])
    @development.start!
    flash[:notice] = 'Development marked as started'
    redirect_to development_path(@development)
  end

  def complete_confirmation
    @development = Development.find(params[:id])
  end

  def complete
    @development = Development.find(params[:id])
    @development.complete!
    flash[:notice] = 'Development marked as completed'
    redirect_to development_path(@development)
  end

  private

  def development_params
    params.require(:development).permit(:application_number, :site_address, :proposal)
  end
end
