class PlaylistInvitesController < ApplicationController

  def create
    PlaylistInviteMailer.invitation(params[:invitee_emails]).deliver
    respond_to do |format|
      format.js
    end
  end
end