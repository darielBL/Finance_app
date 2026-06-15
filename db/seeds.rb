# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# ============================================
# 1. CATEGORÍAS BASE (código existente)
# ============================================

# Categorías base (comunes para todos los usuarios)
base_categories = ["Comida", "Vivienda", "Transporte", "Ocio", "Salud", "Educación"]

base_categories.each do |cat_name|
  Category.find_or_create_by(name: cat_name, user_id: nil) do |category|
    category.deleted_at = nil
  end
end

puts "Categorías base creadas: #{base_categories.join(', ')}"

# ============================================
# 2. TASAS DE CAMBIO (nuevo código)
# ============================================

puts "\n🌱 Sembrando tasas de cambio históricas..."

rates_data = [
  { date: "2026-05-15", usd_cup: 545, eur_cup: 625, cla_cup: 523.86, zelle_cup: 549.23 },
  { date: "2026-05-16", usd_cup: 545, eur_cup: 625, cla_cup: 523.86, zelle_cup: 549.23 },
  { date: "2026-05-17", usd_cup: 550, eur_cup: 628, cla_cup: 528.57, zelle_cup: 554.50 },
  { date: "2026-05-18", usd_cup: 550, eur_cup: 630, cla_cup: 529.11, zelle_cup: 555.23 },
  { date: "2026-05-19", usd_cup: 552, eur_cup: 632, cla_cup: 531.23, zelle_cup: 557.41 },
  { date: "2026-05-20", usd_cup: 555, eur_cup: 635, cla_cup: 534.02, zelle_cup: 560.32 },
  { date: "2026-05-21", usd_cup: 557, eur_cup: 637, cla_cup: 535.87, zelle_cup: 562.11 },
  { date: "2026-05-22", usd_cup: 558, eur_cup: 638, cla_cup: 536.68, zelle_cup: 563.01 },
  { date: "2026-05-23", usd_cup: 560, eur_cup: 640, cla_cup: 538.93, zelle_cup: 565.32 },
  { date: "2026-05-24", usd_cup: 560, eur_cup: 640, cla_cup: 541.70, zelle_cup: 566.42 },
  { date: "2026-05-25", usd_cup: 560, eur_cup: 635, cla_cup: 540.98, zelle_cup: 565.78 },
  { date: "2026-05-26", usd_cup: 565, eur_cup: 640, cla_cup: 545.21, zelle_cup: 570.20 },
  { date: "2026-05-27", usd_cup: 565, eur_cup: 640, cla_cup: 545.45, zelle_cup: 570.40 },
  { date: "2026-05-28", usd_cup: 570, eur_cup: 645, cla_cup: 550.25, zelle_cup: 575.42 },
  { date: "2026-05-29", usd_cup: 575, eur_cup: 650, cla_cup: 555.09, zelle_cup: 580.45 },
  { date: "2026-05-30", usd_cup: 580, eur_cup: 660, cla_cup: 560.06, zelle_cup: 585.47 },
  { date: "2026-05-31", usd_cup: 585, eur_cup: 665, cla_cup: 565.05, zelle_cup: 590.50 },
  { date: "2026-06-01", usd_cup: 585, eur_cup: 670, cla_cup: 565.78, zelle_cup: 590.90 },
  { date: "2026-06-02", usd_cup: 590, eur_cup: 680, cla_cup: 571.21, zelle_cup: 596.21 },
  { date: "2026-06-03", usd_cup: 600, eur_cup: 690, cla_cup: 580.68, zelle_cup: 606.29 },
  { date: "2026-06-04", usd_cup: 610, eur_cup: 700, cla_cup: 590.04, zelle_cup: 616.21 },
  { date: "2026-06-05", usd_cup: 610, eur_cup: 700, cla_cup: 590.34, zelle_cup: 616.41 },
  { date: "2026-06-06", usd_cup: 615, eur_cup: 705, cla_cup: 595.03, zelle_cup: 621.53 },
  { date: "2026-06-07", usd_cup: 620, eur_cup: 715, cla_cup: 600.39, zelle_cup: 626.62 },
  { date: "2026-06-08", usd_cup: 625, eur_cup: 725, cla_cup: 575.95, zelle_cup: 605.97 },
  { date: "2026-06-09", usd_cup: 630, eur_cup: 710, cla_cup: 574.45, zelle_cup: 607.47 },
  { date: "2026-06-10", usd_cup: 640, eur_cup: 745, cla_cup: 618.32, zelle_cup: 646.20 },
  { date: "2026-06-11", usd_cup: 650, eur_cup: 755, cla_cup: 627.45, zelle_cup: 656.10 },
  { date: "2026-06-12", usd_cup: 655, eur_cup: 760, cla_cup: 632.08, zelle_cup: 661.25 },
  { date: "2026-06-13", usd_cup: 660, eur_cup: 765, cla_cup: 637.35, zelle_cup: 666.40 },
  { date: "2026-06-14", usd_cup: 670, eur_cup: 770, cla_cup: 647.41, zelle_cup: 676.70 }
]

# Contador para mostrar el progreso
created_count = 0
updated_count = 0

rates_data.each do |rate_data|
  exchange_rate = ExchangeRate.find_or_initialize_by(date: rate_data[:date])

  if exchange_rate.new_record?
    # Es un registro nuevo, lo creamos con todos los valores
    exchange_rate.usd_cup = rate_data[:usd_cup]
    exchange_rate.eur_cup = rate_data[:eur_cup]
    exchange_rate.cla_cup = rate_data[:cla_cup]
    exchange_rate.zelle_cup = rate_data[:zelle_cup]
    exchange_rate.save!
    created_count += 1
    puts "   ✅ Creada tasa para #{rate_data[:date]}"
  else
    # El registro ya existe, verificamos si falta algún campo y lo actualizamos
    needs_update = false

    if exchange_rate.usd_cup.nil? && rate_data[:usd_cup]
      exchange_rate.usd_cup = rate_data[:usd_cup]
      needs_update = true
    end

    if exchange_rate.eur_cup.nil? && rate_data[:eur_cup]
      exchange_rate.eur_cup = rate_data[:eur_cup]
      needs_update = true
    end

    if exchange_rate.cla_cup.nil? && rate_data[:cla_cup]
      exchange_rate.cla_cup = rate_data[:cla_cup]
      needs_update = true
    end

    if exchange_rate.zelle_cup.nil? && rate_data[:zelle_cup]
      exchange_rate.zelle_cup = rate_data[:zelle_cup]
      needs_update = true
    end

    if needs_update
      exchange_rate.save!
      updated_count += 1
      puts "   🔄 Actualizada tasa para #{rate_data[:date]} (faltaban campos)"
    else
      puts "   ⏭️  Tasa para #{rate_data[:date]} ya existe completa, omitiendo..."
    end
  end
end

puts "\n🌱 ¡Semillas completadas!"
puts "   📊 #{created_count} registros nuevos creados"
puts "   📊 #{updated_count} registros existentes actualizados"
puts "   📊 Total de registros en BD: #{ExchangeRate.count}"