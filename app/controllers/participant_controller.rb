class ParticipantController < ApplicationController
  before_action :require_participant

  private

  def require_participant
    redirect_to schedule_path, alert: "Brak dostępu" unless Current.user.participant?
  end
end
