class PublicController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @dwellings = Dwelling.unscoped.where(development_id: nil)
  end
end
