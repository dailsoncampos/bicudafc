# frozen_string_literal: true

# Check the market status
class Market
  include HTTParty
  base_uri "https://api.cartolafc.globo.com/"

  def status_opened?
    status = self.class.get('/mercado/status', format: :plain)
    status_parsed = JSON.parse status, symbolize_names: true
    return true if status_parsed[:status_mercado] == 1
  end
end
