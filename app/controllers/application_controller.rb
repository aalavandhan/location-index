class ApplicationController < ActionController::API
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

private

  def respond_with_CRUD_json_response(object,errors=nil)
    
    errors = ["You are not authorized to access this resource"] if object.nil?
    errors = []                                                 if object == true

    errors_present  = object.present? ? object.errors.present? : errors.present?
    error_messages  = object.present? ? object.errors.full_messages : errors

    failure = errors_present or !object.try(:valid?)
    
    resp = {
              :success      => (failure ? 0 : 1),
              :api_response => true,
              :data         => {
                                "#{object.class.name.underscore}" => failure ? nil : object
                               }
           }

    resp.merge!({ :errors => error_messages }) if errors_present

    render :json => resp
  end  

end
