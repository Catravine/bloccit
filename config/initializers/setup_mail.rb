if Rails.env.development? || Rails.env.production?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: '2525',
    authentication: :plain,
    user_name: ENV['SENDGRID_USERNAME'],
    password: ENV['SENDGRIG_PASSWORD'],
    domain: 'heroku.com',
    enable_starttls_auto: true
  }
end
