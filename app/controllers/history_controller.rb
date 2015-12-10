class HistoryController < ApplicationController
  def new
    if !logged_in?
      redirect_to login_path
    else
      @transaction = Transaction.where("user_id = ?", current_user.id)
    end
  end
end
