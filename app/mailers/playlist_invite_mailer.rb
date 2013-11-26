class PlaylistInviteMailer < ActionMailer::Base
  default from: "invite@wemote.com"

  def invitation(emails)
    recipients = []
    emails.split(" ").each do |emails_|
      emails_.split(",").each do |email|
        recipients.push(email)
      end
    end
    mail to: recipients
  end
end