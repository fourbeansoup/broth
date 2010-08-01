class UserMailer < Mailer

  def welcome_email(user_id)
    user = User.find(user_id)
    setup_template('welcome', user.email) do |options|
      options['user'] = user
    end
  end
  
end
