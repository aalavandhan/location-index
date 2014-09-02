class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

private

  def authorize!
    access_token = params[:access_token]
    unless access_token.present? and !AccessToken.find_by_token(access_token).try(:invalid?)
      respond_with_CRUD_json_response_for_collection(nil)
    end
  end

  def authorize_admin!
    unless ENV['ADMIN_ACCESS_TOKEN'] == params[:admin_access_token]
      respond_with_CRUD_json_response_for_collection(nil)
    end
  end 

  def respond_with_CRUD_json_response(object,errors=nil)
    
    errors ||= []
    errors = ["You are not authorized to access this resource"] if object.nil?

    errors_present  = object.present? ? object.try(:errors).present? : errors.present?
    error_messages  = errors_present  ? object.errors.try(:full_messages) : errors

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

  def respond_with_CRUD_json_response_for_collection(collection,options=nil,errors=nil)

    errors ||= []

    errors << ["Your access_token is invalid"]   if collection.nil?
    errors << ["There were no results for your query at the time"] if collection.try(:empty?)

    failure = errors.present?

    #collection.class.to_s.split("::").last.split("_").last.underscore.pluralize
    collection_name = !failure ? "restaurants" : "noop"
    
    resp = {
              :success      => (failure ? 0 : 1),
              :api_response => true,
              :data         => {
                                "#{collection_name}" => failure ? nil : collection
                               }
           }
           
    resp.merge!(options)                        if options.present?
    resp.merge!({ :errors => errors })          if errors.present?

    end_timer!
    resp.merge!({ :query_time => @query_time }) if @query_time.present?

    render :json => resp
  end

  def end_timer!
    @query_time = Time.now - @start_time if (@start_time)
  end
end
