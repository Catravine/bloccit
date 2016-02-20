class WelcomeController < ApplicationController

  skip_before_filter :require_sign_in
  
  def index
  end

  def about
  end
end
