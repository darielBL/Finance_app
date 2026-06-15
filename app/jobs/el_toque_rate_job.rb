class ElToqueRateJob < ApplicationJob
  queue_as :default

  def perform
    rates = ElToqueApi.fetch_rates

    exchange_rate = ExchangeRate.find_or_initialize_by(date: rates[:date])
    exchange_rate.update!(rates)

    Rails.logger.info "[ElToqueRateJob] Tasas actualizadas para #{rates[:date]}: #{rates.inspect}"
  rescue ElToqueApi::MissingTokenError => e
    Rails.logger.warn "[ElToqueRateJob] #{e.message} — salteando fetch"
  rescue StandardError => e
    Rails.logger.error "[ElToqueRateJob] Error al obtener tasas: #{e.message}"
    raise
  end
end
