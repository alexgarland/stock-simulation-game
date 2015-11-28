class QuotesController < ApplicationController
  def new
  end

  def get_quote
    yahoo_client = YahooFinance::Client.new
    @stock_symbol = params[:symbol]
    @data = yahoo_client.quotes(params[:symbol], [:last_trade_price])
  end
end
