class PlaylistInviteMailer < ActionMailer::Base
  default from: "invite@wemote.com"

  def invitation(emails, playlist_id)
    recipients = []
    emails.split(" ").each do |emails_|
      emails_.split(",").each do |email|
        recipients.push(email)
      end
    end
    @playlist_link = url_for controller: 'playlists',
                             action: 'search',
                             id: playlist_id
    mail bcc: recipients
  end
end