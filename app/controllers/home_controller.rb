class HomeController < ApplicationController
  layout "landing"
  allow_unauthenticated_access only: %i[ index ]
  def index
    redirect_to home_path_for(Current.user) if authenticated?
  end
end
