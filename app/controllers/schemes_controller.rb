class SchemesController < ApplicationController
  def index
    @schemes = Scheme.all
  end

  def new
    @scheme = Scheme.new
  end

  def create
    @scheme = Scheme.new(scheme_params)
    if @scheme.save
      flash[:notice] = 'Scheme successfully created'
      if params[:development_id]
        associate_development_and_redirect
      else
        redirect_to scheme_path(@scheme)
      end
    else
      render action: :new
    end
  end

  def show
    @scheme = Scheme.find(params[:id])
    @dwellings_statistics = DwellingsStatistics.new(@scheme.dwellings)
  end

  def edit
    @scheme = Scheme.find(params[:id])
  end

  def update
    @scheme = Scheme.find(params[:id])
    if @scheme.update(scheme_params)
      flash[:notice] = 'Scheme successfully saved'
      redirect_to scheme_path(@scheme)
    else
      render action: :edit
    end
  end

  private

  def scheme_params
    params.require(:scheme).permit(
      :name,
      :application_number,
      :site_address,
      :proposal,
      :developer
    )
  end

  def associate_development_and_redirect
    development = Development.find(params[:development_id])
    @scheme.developments << development
    redirect_to development_path(development)
  end
end
