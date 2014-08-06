class AboutController < ApplicationController
  skip_before_action :ensure_current_user, only: :show

  def show
  end

end
