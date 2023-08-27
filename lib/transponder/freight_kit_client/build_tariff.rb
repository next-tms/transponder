# frozen_string_literal: true

module Transponder
  module FreightKitClient
    class BuildTariff
      def initialize(tariff:)
        @tariff = tariff
      end

      def call
        FreightKit::Tariff.new(freight_kit_tariff)
      end

      private

      attr_reader :tariff

      def freight_kit_tariff
        {
          overlength_rules: tariff.to_hash[:overlength_rules].map do |overlength_rule|
                              fee_cents = overlength_rule.dig(:cost, :fractional)

                              max_length = if overlength_rule[:maximum_length].present?
                                             unit = overlength_rule[:maximum_length].keys.first
                                             value = overlength_rule.dig(:maximum_length, unit)

                                             Measured::Length.new(value, unit).convert_to(:inch)
                                           end

                              unit = overlength_rule[:minimum_length].keys.first
                              value = overlength_rule.dig(:minimum_length, unit)
                              min_length = Measured::Length.new(value, unit).convert_to(:inch)

                              { fee_cents:, max_length:, min_length: }
                            end
        }
      end
    end
  end
end
