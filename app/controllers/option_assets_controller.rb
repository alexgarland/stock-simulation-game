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
      amount = params[:amount][0].to_f
      user_cash = current_user.cash
      transaction_type = params[:asset_type]

      Quandl::ApiConfig.api_key = 'vgSUVfxH3nTR8sC4p1cN'
      Quandl::ApiConfig.api_version = '2015-04-09'
      treasury_yield = Quandl::Dataset.get('USTREASURY/YIELD').data
      @yield_num = treasury_yield[0]["2_yr"] * 0.01

      arr = Array.new

      @historical_data.each do |i|
        arr.push(i.close.to_f)
      end

      @daily_sd = OptionAssetsHelper.standard_deviation(arr)
      @daily_sd = @daily_sd / arr[0]
      strike = params[:strike][0].to_f
      duration = params[:duration][0].to_f

      # Option::Calculator.price_call( underlying, strike, time, interest, sigma, dividend )
      if (transaction_type == "Call")
        @option_cost = Option::Calculator.price_call( @data[0].last_trade_price.to_f, strike, duration, @yield_num, @daily_sd, 0.0 )
      else
        @option_cost = Option::Calculator.price_put( @data[0].last_trade_price.to_f, strike, duration, @yield_num, @daily_sd, 0.0 )
      end

      if (user_cash.to_f - @option_cost * amount < 0)
        redirect_to error_path
        return
      end

      User.where(:id => current_user.id).update_all(:cash => user_cash.to_f - @option_cost * amount)

      @transaction = Transaction.create(symbol: stock_symbol, cost: @option_cost*amount,
                                        asset_type: transaction_type, price: @option_cost,
                                        shares: amount.to_i, user_id: current_user.id)

      @option_asset = OptionAsset.create(symbol: stock_symbol, asset_type: transaction_type,
                                         strike_price: strike, user_id: current_user.id, number: amount)

      #Return to index upon success
      redirect_to root_path

      #If stock not found, then return error.
    rescue OpenURI::HTTPError
      redirect_to error_path
    end
  end
end
