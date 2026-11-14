class SchedulesController < ApplicationController
  def show
    @groups = Group.order(:weekday, :starts_at).includes(:course, :instructor)
  end
end
