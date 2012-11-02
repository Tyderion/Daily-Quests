class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_locale

  def index
    render 'test'
  end


  # Set the locale
  #
  def set_locale
      I18n.locale = params[:locale] || session[:locale] || ((lang = request.env['HTTP_ACCEPT_LANGUAGE']) && lang[/^[a-z]{2}/])
      session[:locale] = I18n.locale  # store locale to session
  end

end
