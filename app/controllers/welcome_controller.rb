class WelcomeController < ApplicationController
  
  skip_before_action :authenticate_user!, only: [:index]
  # skiping authentication for welcome page only:
  
  def index
  end
end
