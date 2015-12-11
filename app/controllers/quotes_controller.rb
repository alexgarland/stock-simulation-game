class QuotesController < ApplicationController
  def new
    if !logged_in?
      redirect_to login_path
    end
  end

  def get_quote
    begin
      yahoo_client = YahooFinance::Client.new
      @stock_symbol = params[:symbol]
      @data = yahoo_client.quotes(params[:symbol], [:last_trade_price])
      @historical_data = yahoo_client.historical_quotes(@stock_symbol[0], {raw: false, start_date: Date.today - 365, end_date: Date.today})

    #Upon failure to find stock in @historical_data, redirect to error page.
    rescue OpenURI::HTTPError
      redirect_to error_path
    end
  end

  def quote_error
  end
end

