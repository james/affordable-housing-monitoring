class DevelopmentsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[completion_response_form completion_response]
  def index
    @developments = if params.dig(:search, :q).present?
                      Development.search(params[:search][:q])
                    else
                      Development.all
                    end
  end

  def new
    @development = Development.new
    @development.planning_applications.build
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
    @dwellings_statistics = DwellingsStatistics.new(@development.dwellings)
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
    @development = Development.find_by!(id: params[:id], developer_access_key: params[:dak], state: 'completed')

    render action: :completion_response if @development.completion_response_filled?
  end

  def completion_response
    @development = Development.find_by!(id: params[:id], developer_access_key: params[:dak], state: 'completed')
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
    params.require(:development).permit(
      :name,
      :application_number,
      :site_address,
      :proposal,
      :developer,
      :audit_comment,
      :audit_planning_application_id,
      planning_applications_attributes: [:application_number]
    )
  end

  def completion_response_params
    params.require(:development).permit(dwellings_attributes: %i[id address registered_provider_id])
  end
end
