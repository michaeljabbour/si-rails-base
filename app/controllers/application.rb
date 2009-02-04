# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include SslRequirement
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '321987e5499997d56ab5ba971655d56d'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :credit_card_number, :password
  
  def rescue_action_in_public(exception)
    if exception.class == ActionController::UnknownAction
      Courier.deliver_message(
        ['admin@domain.com'],
        'Page Not Found',
        "The following page was errantly accessed:",
        "http://www.domain.com/#{params[:controller] != 'site' ? params[:controller] + '/' : ''}#{params[:action]}"
      )
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404#,layout => 'somelayout'
    else
      Courier.deliver_message(
        ['developer@domain.com'],
        "Exception: #{exception.class.to_s}",
        "<em>#{exception.class.to_s}</em>",
        exception.backtrace.join("\n").to_s.gsub('<','&lt;').gsub('>', '&gt;')
      )
      render :file => "#{RAILS_ROOT}/public/500.html", :status => 500#,layout => 'somelayout'
    end
  end

  def local_request?
    false
  end
end
