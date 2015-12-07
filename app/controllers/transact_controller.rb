class TransactController < ApplicationController
  def new
  end

  def perform
    yahoo = YahooFinance::Client.new
    @data = yahoo.quotes(params[:symbol], [:last_trade_price])
    stock_symbol = params[:symbol][0]
    asset_price = @data[0].last_trade_price
    amount = params[:amount][0]
    asset_cost = asset_price.to_f * amount.to_f
    user_cash = current_user.cash
    @asset = Portfolio.create(symbol: stock_symbol, value: asset_cost, asset_type: params[:asset_type],
                              price: asset_price, user_id: current_user.id, number: amount)
    current_user.cash = user_cash.to_f - asset_cost.to_f
    User.where(:id => current_user.id).update_all(:cash => user_cash.to_f - asset_cost.to_f)
    @transaction = Transaction.create(symbol: stock_symbol, cost: asset_cost,
                                      asset_type: params[:asset_type], price: asset_price,
                                      shares: amount.to_i, user_id: current_user.id)
    redirect_to root_path
  end
end
