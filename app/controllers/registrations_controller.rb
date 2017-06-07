class RegistrationsController < Devise::RegistrationsController
	
	def create
    # similar to devise reg controller but with some changes as we need to create payment with user registration
		build_resource(sign_up_params)

    resource.class.transaction do # with transaction, if any exceptions raised, db will be rolled back to previous state
      resource.save
      yield resource if block_given?
      # means that we can pass some code in as a block 
      # (which is just an anonymous function) that will receive the resource as a parameter.
      if resource.persisted?
  	    @payment = Payment.new({ email: params["user"]["email"],
  					          token: params[:payment]["token"], user_id: resource.id })
        
  			flash[:error] = "Please check registration errors" unless @payment.valid?
  			
  			begin
  				@payment.process_payment # this is a instance method we created in Payment
  				@payment.save
  			rescue Exception => e
  				flash[:error] = e.message
  
  				resource.destroy
  				puts 'Payment failed'
  				render :new and return
  			end
  
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end			
		end
	end
	
  protected # registrationsController class is a sub class or DEvise::RegistrationsController there for can access its methods
  
  def configure_permitted_parameters # this is a Devise related method, since we are adding payment we need to sanitize it
    devise_parameter_sanitizer.for(:sign_up).push(:payment)
  end
end