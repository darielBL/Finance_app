
namespace :rates do
  desc "Actualiza las tasas de cambio del día actual"
  task :update, [:usd, :eur, :cla, :zelle] => :environment do |t, args|
    # Establecer valores por defecto si no se proporcionan
    usd = args[:usd].to_d if args[:usd].present?
    eur = args[:eur].to_d if args[:eur].present?
    cla = args[:cla].to_d if args[:cla].present?
    zelle = args[:zelle].to_d if args[:zelle].present?
    
    date = Date.today
    
    # Buscar o crear el registro para hoy
    rate = ExchangeRate.find_or_initialize_by(date: date)
    
    # Actualizar solo los campos que recibieron valores
    rate.usd_cup = usd if usd.present?
    rate.eur_cup = eur if eur.present?
    rate.cla_cup = cla if cla.present?
    rate.zelle_cup = zelle if zelle.present?
    
    if rate.save
      puts "\n✅ Tasas actualizadas exitosamente para #{date}"
      puts "   📊 USD: #{rate.usd_cup} CUP" if rate.usd_cup.present?
      puts "   📊 EUR: #{rate.eur_cup} CUP" if rate.eur_cup.present?
      puts "   📊 CLA: #{rate.cla_cup} CUP" if rate.cla_cup.present?
      puts "   📊 Zelle: #{rate.zelle_cup} CUP" if rate.zelle_cup.present?
    else
      puts "\n❌ Error al guardar las tasas:"
      puts "   #{rate.errors.full_messages.join(', ')}"
    end
  end
  
  desc "Muestra las tasas del día actual"
  task today: :environment do
    rate = ExchangeRate.find_by(date: Date.today)
    
    if rate
      puts "\n📈 Tasas para #{Date.today}:"
      puts "   USD: #{rate.usd_cup} CUP" if rate.usd_cup
      puts "   EUR: #{rate.eur_cup} CUP" if rate.eur_cup
      puts "   CLA: #{rate.cla_cup} CUP" if rate.cla_cup
      puts "   Zelle: #{rate.zelle_cup} CUP" if rate.zelle_cup
    else
      puts "\n⚠️  No hay tasas registradas para #{Date.today}"
      puts "   Ejecuta: rails rates:update[usd,eur,cla,zelle]"
    end
  end
  
  desc "Verifica si hay datos faltantes en los últimos días"
  task check_missing: :environment do
    missing_dates = []
    
    # Verificar últimos 7 días
    (0..6).each do |days_ago|
      date = Date.today - days_ago
      rate = ExchangeRate.find_by(date: date)
      
      if rate.nil?
        missing_dates << date
      elsif rate.usd_cup.nil? || rate.eur_cup.nil?
        puts "⚠️  Datos incompletos para #{date}:"
        puts "   USD: #{rate.usd_cup || 'faltante'}"
        puts "   EUR: #{rate.eur_cup || 'faltante'}"
        puts "   CLA: #{rate.cla_cup || 'faltante'}"
        puts "   Zelle: #{rate.zelle_cup || 'faltante'}"
      end
    end
    
    if missing_dates.any?
      puts "\n📅 Fechas sin registrar en los últimos 7 días:"
      missing_dates.each { |date| puts "   - #{date}" }
    else
      puts "\n✅ Todos los días de la última semana tienen datos"
    end
  end
end
