class HistoryController < ApplicationController
  def new
    if !logged_in?
      redirect_to login_path
    #find the transactions he was involved in
    else
      @hist_transaction = Transaction.where("user_id = ?", current_user.id)
    end
  end
end
