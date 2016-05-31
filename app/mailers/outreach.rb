class Outreach < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.outreach.new_user.subject
  #
  def welcome(user)
    @header_message = "Hi " + user.name
    @message = "Thank you for joining the Newton family! We look forward to introducing you and your party to talented local artists!"
    @footer_message = "Your friends at Newton :) "
    mail to: user.email
  end

  def direct_user_message(email, title, message, footer)
    @header_message = title
    @message        = message
    @footer_message = footer
    mail to: email
  end

end
