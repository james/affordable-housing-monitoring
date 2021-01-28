class DevelopmentsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[
    completion_response_form
    completion_response
    rp_response_form
    rp_response
  ]
  def index
    if params.dig(:search, :q).present?
      @developments = Development.search(params[:search][:q])
      @dwellings_statistics = DwellingsStatistics.new(Dwelling.where(development_id: @developments))
    else
      @developments = Development.all
      @dwellings_statistics = DwellingsStatistics.new(Dwelling.all)
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
      redirect_to development_path(@development, anchor: 'dwellings')
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

  def add_to_scheme
    @development = Development.find(params[:id])
  end

  def destroy
    @development = Development.find(params[:id])
    @development.destroy
    flash[:notice] = 'Development deleted'
    redirect_to developments_path
  end

  def agree_confirmation
    @development = Development.find(params[:id])
  end

  def agree
    @development = Development.find(params[:id])
    @development.update!(params.require(:development).permit(:agreed_on_dd, :agreed_on_mm, :agreed_on_yyyy))
    @development.agree!
    flash[:notice] = 'Development marked as agreed'
    redirect_to development_path(@development)
  end

  def start_confirmation
    @development = Development.find(params[:id])
  end

  def start
    @development = Development.find(params[:id])
    @development.update!(params.require(:development).permit(:started_on_dd, :started_on_mm, :started_on_yyyy))
    @development.start!
    flash[:notice] = 'Development marked as started'
    redirect_to development_path(@development)
  end

  def complete_confirmation
    @development = Development.find(params[:id])
  end

  def complete
    @development = Development.find(params[:id])
    @development.unconfirmed_complete!
    flash[:notice] = 'Development marked as completed'
    redirect_to development_path(@development)
  end

  def completion_response_form
    find_development_for_completion_response

    render action: :completion_response if @development.completion_response_filled?
  end

  def completion_response
    find_development_for_completion_response
    @development.update!(completion_response_params)
    @development.reload
    if @development.completion_response_filled?
      @development.partially_confirmed_complete!
      render
    else
      flash[:notice] = 'Your changes have been saved. We still need more information from you'
      render action: :completion_response_form
    end
  end

  def rp_response_form
    find_development_for_rp_response
  end

  def rp_response
    find_development_for_rp_response
    @development.update!(rp_response_params)
    @development.confirmed_complete!
  end

  private

  def find_development_for_completion_response
    @development = Development.find_by!(
      id: params[:id],
      developer_access_key: params[:dak],
      state: 'unconfirmed_completed'
    )
  end

  def find_development_for_rp_response
    @development = Development.find_by!(
      id: params[:id],
      rp_access_key: params[:rpak],
      state: 'partially_confirmed_completed'
    )
  end

  def development_params
    params.require(:development).permit(
      :name,
      :application_number,
      :site_address,
      :proposal,
      :developer,
      :audit_comment,
      :audit_planning_application_id,
      :scheme_id,
      planning_applications_attributes: [:application_number]
    )
  end

  def completion_response_params
    params.require(:development).permit(dwellings_attributes: %i[id address uprn registered_provider_id tenure_product])
  end

  def rp_response_params
    params.require(:development).permit(dwellings_attributes: %i[id rp_internal_id])
  end
end
