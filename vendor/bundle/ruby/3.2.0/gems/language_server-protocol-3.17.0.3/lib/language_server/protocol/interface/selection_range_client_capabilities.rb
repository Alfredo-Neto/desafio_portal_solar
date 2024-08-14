# frozen_string_literal: true

module LanguageServer
  module Protocol
    module Interface
      class SelectionRangeClientCapabilities
        def initialize(dynamic_registration: nil)
          @attributes = {}

          @attributes[:dynamicRegistration] = dynamic_registration if dynamic_registration

          @attributes.freeze
        end

        #
        # Whether implementation supports dynamic registration for selection range
        # providers. If this is set to `true` the client supports the new
        # `SelectionRangeRegistrationOptions` return value for the corresponding
        # server capability as well.
        #
        # @return [boolean]
        def dynamic_registration
          attributes.fetch(:dynamicRegistration)
        end

        attr_reader :attributes

        def to_hash
          attributes
        end

        def to_json(*args)
          to_hash.to_json(*args)
        end
      end
    end
  end
end
