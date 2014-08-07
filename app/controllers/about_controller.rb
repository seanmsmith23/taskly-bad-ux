class AboutController < ApplicationController
  skip_before_action :ensure_current_user, only: :index

  def index
  end

end
