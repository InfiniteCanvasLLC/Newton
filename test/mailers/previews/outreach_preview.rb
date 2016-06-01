# Preview all emails at http://localhost:3000/rails/mailers/outreach
class OutreachPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/outreach/new_user
  def new_user
    Outreach.new_user
  end

end
