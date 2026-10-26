# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      # @note `object` is a `FreightKit::Carrier` subclass, with or without an API.
      class CarrierType < BaseObject
        field :acts_as_broker, Boolean, null: false, method: :acts_as_broker?
        field :bol_requires_tracking_number, Boolean, null: false, method: :bol_requires_tracking_number?
        field :check_mailing_addresses, [CarrierAddressType], null: false
        field :consider_bol_and_pod_documents_same, Boolean, null: false, method: :consider_bol_and_pod_documents_same?
        field :contacts, [CarrierContactType], null: false
        field :create_pickup_implemented, Boolean, null: false, method: :create_pickup_implemented?
        field :find_rates_implemented, Boolean, null: false, method: :find_rates_implemented?
        field :find_rates_with_declared_value, Boolean, null: false, method: :find_rates_with_declared_value?
        field :headquarters, CarrierAddressType, null: true
        field :id, ID, null: false
        field :legal_name, String, null: true
        field :maximum_height, LengthType, null: false
        field :maximum_weight, WeightType, null: false
        field :minimum_length_for_overlength_fees, LengthType, null: false
        field :name, String, null: false
        field :pickup_number_is_tracking_number, Boolean, null: false, method: :pickup_number_is_tracking_number?
        field :quote_declared_value,
              Boolean,
              null: false,
              method: :find_rates_with_declared_value?,
              deprecation_reason: 'Use `findRatesWithDeclaredValue`.'
        field :quote_overlength_with_tariff, Boolean, null: false, method: :overlength_fees_require_tariff?
        field :rates_with_excessive_length_fees, Boolean, null: false, method: :rates_with_excessive_length_fees?
        field :required_credential_types, [CarrierCredentialCategory], null: false
        field :scac, String, null: true
        field :terminals, [TerminalType], null: false
        field :us_dot_number, String, null: true
        field :us_mc_number, String, null: true
        field :valid_tracking_number_pattern, String, null: true, description: 'Ruby regular expression source'
        field :website_url, String, null: true

        def valid_tracking_number_pattern = object.valid_number_regex(:tracking_number)&.source
      end
    end
  end
end
