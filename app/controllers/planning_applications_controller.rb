class PlanningApplicationsController < ApplicationController
  before_action :find_development

  def index
    @planning_applications = @development.planning_applications
  end

  def new
    @planning_application = @development.planning_applications.build
  end

  def create
    @planning_application = @development.planning_applications.build(planning_application_params)
    if @planning_application.save
      flash[:notice] = 'Planning application successfully added'
      redirect_to development_planning_applications_path(@development)
    else
      render action: :new
    end
  end

  private

  def find_development
    @development = Development.find(params[:development_id])
  end

  def planning_application_params
    params.require(:planning_application).permit(:application_number)
  end
end
