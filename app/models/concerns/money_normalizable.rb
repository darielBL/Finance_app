# app/models/concerns/money_normalizable.rb
module MoneyNormalizable
  extend ActiveSupport::Concern

  included do
    attr_accessor :normalized_amount

    before_validation :set_cents_from_normalized, if: -> { normalized_amount.present? }
    before_validation :clear_normalized_amount

    def normalized_amount
      if respond_to?(:amount) && amount.present?
        @normalized_amount ||= (amount.cents / 100.0) if amount.cents
      elsif respond_to?(:estimated_amount) && estimated_amount.present?
        @normalized_amount ||= (estimated_amount.cents / 100.0) if estimated_amount.cents
      elsif respond_to?(:actual_amount) && actual_amount.present?
        @normalized_amount ||= (actual_amount.cents / 100.0) if actual_amount.cents
      else
        @normalized_amount
      end
    end

    private

    def set_cents_from_normalized
      clean_amount = normalized_amount.to_s.gsub(/[^0-9.-]/, '')
      if respond_to?(:amount_cents=)
        self.amount_cents = (clean_amount.to_f * 100).round.to_i
      elsif respond_to?(:estimated_amount_cents=)
        self.estimated_amount_cents = (clean_amount.to_f * 100).round.to_i
      elsif respond_to?(:actual_amount_cents=)
        self.actual_amount_cents = (clean_amount.to_f * 100).round.to_i
      end
    end

    def clear_normalized_amount
      self.normalized_amount = nil if normalized_amount.blank?
    end
  end
end