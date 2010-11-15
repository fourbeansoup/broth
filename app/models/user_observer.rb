class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.deliver_welcome_email(user.id) unless (user.admin? && User.count == 1)
  end
  
end
