# frozen_string_literal: true

module LanguageServer
  module Protocol
    module Interface
      #
      # Inlay hint options used during static or dynamic registration.
      #
      class InlayHintRegistrationOptions
        def initialize(work_done_progress: nil, resolve_provider: nil, document_selector:, id: nil)
          @attributes = {}

          @attributes[:workDoneProgress] = work_done_progress if work_done_progress
          @attributes[:resolveProvider] = resolve_provider if resolve_provider
          @attributes[:documentSelector] = document_selector
          @attributes[:id] = id if id

          @attributes.freeze
        end

        # @return [boolean]
        def work_done_progress
          attributes.fetch(:workDoneProgress)
        end

        #
        # The server provides support to resolve additional
        # information for an inlay hint item.
        #
        # @return [boolean]
        def resolve_provider
          attributes.fetch(:resolveProvider)
        end

        #
        # A document selector to identify the scope of the registration. If set to
        # null the document selector provided on the client side will be used.
        #
        # @return [DocumentSelector]
        def document_selector
          attributes.fetch(:documentSelector)
        end

        #
        # The id used to register the request. The id can be used to deregister
        # the request again. See also Registration#id.
        #
        # @return [string]
        def id
          attributes.fetch(:id)
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
