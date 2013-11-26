class PlaylistInvitesController < ApplicationController

  def create
    PlaylistInviteMailer.invitation(params[:email]).deliver
    respond_to do |format|
      format.js
    end
  end
end