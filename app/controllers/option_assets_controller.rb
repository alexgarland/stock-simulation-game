class OptionAssetsController < ApplicationController
  def new
    if !logged_in?
      redirect_to login_path
    end
  end

  def perform
    begin
      #Invoke Yahoo Finance Library
      yahoo = YahooFinance::Client.new

      #Lay out data in variables as needed
      @data = yahoo.quotes(params[:symbol], [:last_trade_price])
      stock_symbol = params[:symbol][0]
      @historical_data = yahoo.historical_quotes(stock_symbol, {raw: false, start_date: Date.today - 365, end_date: Date.today})
      asset_price = @data[0].last_trade_price
      amount = params[:amount][0]
      user_cash = current_user.cash
      transaction_type = params[:asset_type]

      Quandl::ApiConfig.api_key = 'vgSUVfxH3nTR8sC4p1cN'
      Quandl::ApiConfig.api_version = '2015-04-09'
      treasury_yield = Quandl::Dataset.get('USTREASURY/YIELD').data
      @yield_num = treasury_yield[0]["2_yr"] * 0.01

      #Return to index upon sucess
      #redirect_to root_path

      #If stock not found, then return error.
    rescue OpenURI::HTTPError
      redirect_to error_path
    end
  end
end
