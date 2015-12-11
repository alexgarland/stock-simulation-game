class WelcomeController < ApplicationController
  def home
    if !logged_in?
      redirect_to login_path
    else
      #Update user's stats and store them in instance variables we can use in the the view.
      @cash = @current_user.cash
      @net_worth = @cash
      @current_portfolio = Portfolio.where("user_id = ?", @current_user.id)
      yahoo_client = YahooFinance::Client.new
      @current_portfolio.each do |asset|
        stock_symbol = asset.symbol
        price = yahoo_client.quotes([stock_symbol], [:last_trade_price], {raw: false})
        asset_price = price[0].last_trade_price
        asset_value = asset_price.to_f * asset.number
        @net_worth = @net_worth + asset_value
        Portfolio.where("user_id = ? AND symbol = ?", @current_user.id, stock_symbol).update_all(price: asset_price.to_f, value: asset_value)
        User.where("id = ?", @current_user.id).update_all(net_worth: @net_worth)
      end
    end
  end
end
