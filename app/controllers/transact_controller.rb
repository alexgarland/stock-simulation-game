class TransactController < ApplicationController
  def new
    if !logged_in?
      redirect_to login_path
    end
  end

  def perform
    yahoo = YahooFinance::Client.new
    @data = yahoo.quotes(params[:symbol], [:last_trade_price])
    stock_symbol = params[:symbol][0]
    asset_price = @data[0].last_trade_price
    amount = params[:amount][0]
    asset_cost = asset_price.to_f * amount.to_f
    user_cash = current_user.cash
    previous_holdings = Portfolio.where("user_id = ? AND symbol = ?", current_user.id, stock_symbol)
    if previous_holdings.blank?
      @asset = Portfolio.create(symbol: stock_symbol, value: asset_cost, asset_type: params[:asset_type],
                                price: asset_price, user_id: current_user.id, number: amount)
    else
      @asset = Portfolio.where("user_id = ? AND symbol = ?", current_user.id, stock_symbol).take
      prev_amount = @asset.number
      prev_value = @asset.value
      if (prev_amount.to_f + amount.to_f == 0)
        @asset.destroy
      else
        @asset.update(number: prev_amount.to_f + amount.to_f)
        @asset.update(value: prev_value.to_f + asset_cost.to_f, price: asset_price)
      end

    end

    current_user.cash = user_cash.to_f - asset_cost.to_f
    User.where(:id => current_user.id).update_all(:cash => user_cash.to_f - asset_cost.to_f)
    @transaction = Transaction.create(symbol: stock_symbol, cost: asset_cost,
                                      asset_type: params[:asset_type], price: asset_price,
                                      shares: amount.to_i, user_id: current_user.id)
    @transaction.save
    redirect_to root_path
  end
end
