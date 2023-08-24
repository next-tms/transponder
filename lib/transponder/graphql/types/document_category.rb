# frozen_string_literal: true

module Transponder
  module GraphQL
    module Types
      class DocumentCategory < BaseEnum
        value 'POD', value: :pod
        value 'BOL', value: :scanned_bol
      end
    end
  end
end
