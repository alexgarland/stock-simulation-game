class TransactController < ApplicationController
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
      asset_cost = asset_price.to_f * amount.to_f
      user_cash = current_user.cash
      transaction_type = params[:asset_type]
      if (user_cash.to_f - asset_cost.to_f < 0)
        redirect_to error_path
        return
      end

      #If no amount specified, return the error page.
      if (amount == "")
        redirect_to error_path
      elsif (transaction_type == "Option")
        redirect_to options_path
      else

        #Allow for dynamic asset types
        if (amount.to_f > 0)
          transaction_type = transaction_type + " Buy"
        else
          transaction_type = transaction_type + " Sell"
        end

        #Check to see if already in portfolio and use control statements to either add or update
        previous_holdings = Portfolio.where("user_id = ? AND symbol = ?", current_user.id, stock_symbol)
        if previous_holdings.blank?
          @asset = Portfolio.create(symbol: stock_symbol, value: asset_cost, asset_type: params[:asset_type],
                                    price: asset_price, user_id: current_user.id, number: amount)
          if(amount.to_f > 0)
            @asset.update(asset_type: params[:asset_type] + " (Long)")
          else
            @asset.update(asset_type: params[:asset_type] + " (Short)")
          end
        else
          @asset = Portfolio.where("user_id = ? AND symbol = ?", current_user.id, stock_symbol).take
          prev_amount = @asset.number
          prev_value = @asset.value
          if (prev_amount.to_f + amount.to_f == 0)
            @asset.destroy
          else
            @asset.update(number: prev_amount.to_f + amount.to_f)
            @asset.update(value: prev_value.to_f + asset_cost.to_f, price: asset_price)
            if(prev_amount.to_f + amount.to_f > 0)
              @asset.update(asset_type: params[:asset_type] + " (Long)")
            else
              @asset.update(asset_type: params[:asset_type] + " (Short)")
            end
          end

        end

        #Update users cash and then add to this transaction.
        User.where(:id => current_user.id).update_all(:cash => user_cash.to_f - asset_cost.to_f)
        @transaction = Transaction.create(symbol: stock_symbol, cost: asset_cost,
                                          asset_type: transaction_type, price: asset_price,
                                          shares: amount.to_i, user_id: current_user.id)
        @transaction.save

        #Redirect to index upon secess.
        redirect_to root_path
      end
    #If stock not found, then return error.
    rescue OpenURI::HTTPError
      redirect_to error_path
    end
  end
end
