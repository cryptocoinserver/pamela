defmodule Pamela.Trader.ExecuteTrade do
  def execute(trades, base, session, prices, transaction) do
    Enum.map(trades, fn {coin, amount} ->
      amount_trunc = trunc_amount(amount)
      market = "#{coin}#{base.symbol}"

      case exec(amount_trunc, market) do
        {:ok, trade} -> save_trades(trade, coin, session, prices, transaction, base)
        {:error, error} -> save_trades(%{}, coin, session, prices, transaction, base)
      end
    end)
  end

  defp exec(amount, market) when amount > 0 do
    Binance.order_market_buy(market, amount)
  end

  defp exec(amount, market) when amount <= 0 do
    Binance.order_market_sell(market, -amount)
  end

  defp save_trades(trade, coin, session, prices, transaction, base) do
    {_coin, price} = Enum.find(prices, fn {symbol, p} -> symbol === coin end)

    attrs = %{
      amount: trade["executedQty"],
      base: base.symbol,
      coin: coin,
      price: "#{price}",
      rebalance_transaction_id: transaction.id,
      side: trade["side"],
      order_id: trade["orderId"],
      time: DateTime.utc_now()
    }

    case Pamela.Trading.create_trade(attrs) do
      {:ok, trs} -> {:ok, trs}
      {:error, error} -> IO.inspect(error)
    end
  end

  defp trunc_amount(amount) when amount >= 1 do
    trunc(amount)
  end

  defp trunc_amount(amount) when amount < 1 and amount >= 0 do
    amount
  end

  defp trunc_amount(amount), do: trunc(amount)
end
