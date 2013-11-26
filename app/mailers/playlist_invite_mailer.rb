class PlaylistInviteMailer < ActionMailer::Base
  default from: "invite@wemote.com"

  def invitation(email)
    mail to: email
  end
end
