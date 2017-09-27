module GeneralFundsHelper
  def display_strong? line_balance, balance
    raw (line_balance == balance) ? '<strong>'+number_to_currency( line_balance )+'</strong>' : number_to_currency( line_balance )
  end
end
