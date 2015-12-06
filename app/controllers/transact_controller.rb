class TransactController < ApplicationController
  def new
  end

  def perform
    redirect_to root_path
  end
end
