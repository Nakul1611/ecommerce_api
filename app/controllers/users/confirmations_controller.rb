class Users::ConfirmationsController < Devise::ConfirmationsController
  respond_to :json

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    if resource.errors.empty?
      render json: { status: 200, message: "Email confirmed successfully." }
    else
      render json: { status: 422, errors: resource.errors.full_messages }
    end
  end

  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    if successfully_sent?(resource)
      render json: { status: 200, message: "Confirmation instructions sent." }
    else
      render json: { status: 422, errors: resource.errors.full_messages }
    end
  end
end
