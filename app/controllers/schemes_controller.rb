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
      redirect_to scheme_path(@scheme)
    else
      render action: :new
    end
  end

  def show
    @scheme = Scheme.find(params[:id])
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
end
