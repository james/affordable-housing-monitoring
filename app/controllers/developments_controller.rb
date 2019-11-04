class DevelopmentsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[completion_response_form completion_response]
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
      redirect_to development_path(@development)
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
      redirect_to development_path(@development)
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

  def completion_response_form
    @development = Development.find(params[:id])
  end

  def completion_response
    @development = Development.find(params[:id])
    @development.update!(completion_response_params)
    @development.reload
    if @development.completion_response_filled?
      render
    else
      flash[:notice] = 'Your changes have been saved. We still need more information from you'
      render action: :completion_response_form
    end
  end

  private

  def development_params
    params.require(:development).permit(:application_number, :site_address, :proposal, :audit_comment)
  end

  def completion_response_params
    params.require(:development).permit(dwellings_attributes: %i[id address registered_provider_id])
  end
end
