class RemovePaymentMethodDetailFromIncomeSources < ActiveRecord::Migration[8.0]
  def change
    remove_column :income_sources, :payment_method_detail, :string
  end
end
