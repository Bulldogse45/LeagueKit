ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "google.com",
  :user_name            => "myleaguekit",
  :password             => ENV['gmail_password'],
  :authentication       => "plain",
  :enable_starttls_auto => true
}
