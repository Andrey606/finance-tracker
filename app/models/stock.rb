class Stock < ApplicationRecord

  def self.new_lookup(ticker_symbol)
    client = IEX::Api::Client.new(
      publishable_token: 'Tpk_d2ad5a42140445f0bd7102cf5dba8ac0',
      # secret_token: 'secret_token',
      endpoint: 'https://sandbox.iexapis.com/v1'
    )

    client.price(ticker_symbol)
  end

end
