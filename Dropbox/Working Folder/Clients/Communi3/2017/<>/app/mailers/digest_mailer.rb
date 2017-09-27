class DigestMailer < ActionMailer::Base
  default from: "noreply@inrea.ch"

  def aggregated(user, categories)
    @user = user
    @categories = categories

    mail to: user.email, subject: "Your Daily Updates"
  end

  def followup(user, followup)
    @user = user
    @followup = followup

    mail to: user.email, subject: "New Follow-Up to #{followup.announcement.to_s}"
  end
end
