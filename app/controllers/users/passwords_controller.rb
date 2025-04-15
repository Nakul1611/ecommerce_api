class Users::PasswordsController < Devise::PasswordsController
  respond_to :json

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    if successfully_sent?(resource)
      render json: { status: 200, message: "Reset password instructions sent." }
    else
      render json: { status: 422, errors: resource.errors.full_messages }
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      render json: { status: 200, message: "Password has been reset successfully." }
    else
      render json: { status: 422, errors: resource.errors.full_messages }
    end
  end
end
