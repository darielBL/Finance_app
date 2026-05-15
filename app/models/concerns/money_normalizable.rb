# app/models/concerns/money_normalizable.rb
module MoneyNormalizable
  extend ActiveSupport::Concern

  included do
    attr_accessor :normalized_amount

    before_validation :set_cents_from_normalized, if: -> { normalized_amount.present? }
    before_validation :clear_normalized_amount

    def normalized_amount
      if amount.present?
        @normalized_amount ||= (amount.cents / 100.0) if amount.cents
      else
        @normalized_amount
      end
    end

    private

    def set_cents_from_normalized
      # Limpiar el string: remover comas, espacios, símbolos de moneda
      clean_amount = normalized_amount.to_s.gsub(/[^0-9.-]/, '')
      self.amount_cents = (clean_amount.to_f * 100).round.to_i
    end

    def clear_normalized_amount
      self.normalized_amount = nil if normalized_amount.blank?
    end
  end
end