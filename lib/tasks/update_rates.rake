
namespace :rates do
  desc "Obtiene las tasas del día actual desde la API de elTOQUE y las guarda en la BD"
  task fetch_from_api: :environment do
    puts "🌐 Consultando la API de elTOQUE..."

    begin
      # Usar tu nueva clase ElToqueApi
      rates_data = ElToqueApi.fetch_rates

      if rates_data.present?
        date = rates_data[:date] || Date.today
        rate = ExchangeRate.find_or_initialize_by(date: date)

        # Actualizar con los datos de la API
        rate.usd_cup = rates_data[:usd_cup] if rates_data[:usd_cup].present?
        rate.eur_cup = rates_data[:eur_cup] if rates_data[:eur_cup].present?
        rate.cla_cup = rates_data[:cla_cup] if rates_data[:cla_cup].present?
        rate.zelle_cup = rates_data[:zelle_cup] if rates_data[:zelle_cup].present?

        if rate.save
          puts "✅ Tasas del día actualizadas exitosamente desde la API."
          puts "   📊 USD: #{rate.usd_cup} CUP" if rate.usd_cup
          puts "   📊 EUR: #{rate.eur_cup} CUP" if rate.eur_cup
          puts "   📊 CLA: #{rate.cla_cup} CUP" if rate.cla_cup
          puts "   📊 Zelle: #{rate.zelle_cup} CUP" if rate.zelle_cup
        else
          puts "❌ Error al guardar las tasas: #{rate.errors.full_messages.join(', ')}"
        end
      else
        puts "❌ No se pudieron obtener datos de la API."
      end
    rescue ElToqueApi::MissingTokenError => e
      puts "❌ Error: #{e.message}"
      puts "   Asegúrate de que EL_TOQUE_API_TOKEN esté configurado en tus variables de entorno."
    rescue ElToqueApi::ApiError => e
      puts "❌ Error de API: #{e.message}"
    rescue StandardError => e
      puts "❌ Error inesperado: #{e.message}"
      puts e.backtrace.first(5)
    end
  end
end