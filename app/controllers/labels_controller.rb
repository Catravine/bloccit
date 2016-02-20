class LabelsController < ApplicationController

  skip_before_filter :require_sign_in, only: :show
  
  def show
      @label = Label.find(params[:id])
  end
end
