class WelcomeController < ApplicationController
  def home
    if !logged_in?
      redirect_to login_path
    else
      #Update user's stats and store them in instance variables we can use in the the view.
      @cash = @current_user.cash
      @net_worth = @cash
      @current_portfolio = Portfolio.where("user_id = ?", @current_user.id)
      @current_options = OptionAsset.where("user_id = ?", @current_user.id)
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
      @current_options.each do |option|
        stock_symbol = option.symbol
        price = yahoo_client.quotes([stock_symbol], [:last_trade_price], {raw: false})
        asset_price = price[0].last_trade_price
        if option.asset_type == "Call"
          indiv_value = -option.strike_price + asset_price.to_f
        else
          indiv_value = option.strike_price - asset_price.to_f
        end

        if indiv_value < 0
          indiv_value = 0
        end
        total_value = indiv_value*option.number
        option.value = total_value
        option.save
        time_since = Date.today - option.created_at.to_date
        if time_since > option.duration.to_f * 365
          User.where(:id => current_user.id).update_all(:cash => current_user.cash + option.value)
          option.asset_type = "Inactive"
        end
        OptionAsset.destroy_all(:asset_type => "Inactive")
        @current_options = OptionAsset.where("user_id = ?", @current_user.id)
      end
    end
  end
end
