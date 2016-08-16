class ApplicationMailer < ActionMailer::Base
  default from: ENV["GMAIL_USERNAME"]
  layout 'mailer'

  # You can't really e-mail multiple users from inside ActionMailer.  Need to do it from within the controller as described
  # in this article: https://subvisual.co/blog/posts/66-sending-multiple-emails-with-actionmailer
  #
  # So adding a helper method here
  def mail_to_party_id(party_id, email_subject, email_body)
    party = Party.find(party_id)

    emails = Array.new

    party.users.each do |user|
      Outreach.mail_to_user(user, email_subject, email_body).deliver_now
    end
  end

end
