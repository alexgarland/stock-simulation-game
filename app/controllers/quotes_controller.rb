class QuotesController < ApplicationController
  def new
    if !logged_in?
      redirect_to login_path
    end
  end

  def get_quote
    yahoo_client = YahooFinance::Client.new
    @stock_symbol = params[:symbol]
    @data = yahoo_client.quotes(params[:symbol], [:last_trade_price])
  end
end

