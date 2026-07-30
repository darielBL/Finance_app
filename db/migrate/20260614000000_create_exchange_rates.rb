class CreateExchangeRates < ActiveRecord::Migration[8.0]
  def change
    create_table :exchange_rates do |t|
      t.date :date, null: false
      t.decimal :usd_cup, precision: 10, scale: 2
      t.decimal :eur_cup, precision: 10, scale: 2
      t.decimal :cla_cup, precision: 10, scale: 2
      t.decimal :zelle_cup, precision: 10, scale: 2

      t.timestamps
    end

    add_index :exchange_rates, :date, unique: true
  end
end
