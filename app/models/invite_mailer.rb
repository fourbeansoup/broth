class InviteMailer < Mailer
  
  def invite_notification(invite_id)
    invite = Invite.find(invite_id)
    setup_template('invitation', invite.email)
  end
end
