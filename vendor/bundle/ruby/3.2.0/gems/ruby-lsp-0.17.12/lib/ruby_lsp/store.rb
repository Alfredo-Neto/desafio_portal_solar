# frozen_string_literal: true

# typed: strict
# frozen_string_literal: true

module RubyLsp
  class Store
    extend T::Sig

    class NonExistingDocumentError < StandardError; end

    sig { returns(T::Boolean) }
    attr_accessor :supports_progress

    sig { returns(T::Hash[Symbol, RequestConfig]) }
    attr_accessor :features_configuration

    sig { returns(String) }
    attr_accessor :client_name

    sig { void }
    def initialize
      @state = T.let({}, T::Hash[String, Document])
      @supports_progress = T.let(true, T::Boolean)
      @features_configuration = T.let(
        {
          inlayHint: RequestConfig.new({
            enableAll: false,
            implicitRescue: false,
            implicitHashValue: false,
          }),
        },
        T::Hash[Symbol, RequestConfig],
      )
      @client_name = T.let("Unknown", String)
    end

    sig { params(uri: URI::Generic).returns(Document) }
    def get(uri)
      document = @state[uri.to_s]
      return document unless document.nil?

      # For unsaved files (`untitled:Untitled-1` uris), there's no path to read from. If we don't have the untitled file
      # already present in the store, then we have to raise non existing document error
      path = uri.to_standardized_path
      raise NonExistingDocumentError, uri.to_s unless path

      ext = File.extname(path)
      language_id = if ext == ".erb" || ext == ".rhtml"
        Document::LanguageId::ERB
      else
        Document::LanguageId::Ruby
      end

      set(uri: uri, source: File.binread(path), version: 0, language_id: language_id)
      T.must(@state[uri.to_s])
    rescue Errno::ENOENT
      raise NonExistingDocumentError, uri.to_s
    end

    sig do
      params(
        uri: URI::Generic,
        source: String,
        version: Integer,
        language_id: Document::LanguageId,
        encoding: Encoding,
      ).void
    end
    def set(uri:, source:, version:, language_id:, encoding: Encoding::UTF_8)
      document = case language_id
      when Document::LanguageId::ERB
        ERBDocument.new(source: source, version: version, uri: uri, encoding: encoding)
      else
        RubyDocument.new(source: source, version: version, uri: uri, encoding: encoding)
      end
      @state[uri.to_s] = document
    end

    sig { params(uri: URI::Generic, edits: T::Array[T::Hash[Symbol, T.untyped]], version: Integer).void }
    def push_edits(uri:, edits:, version:)
      T.must(@state[uri.to_s]).push_edits(edits, version: version)
    end

    sig { void }
    def clear
      @state.clear
    end

    sig { returns(T::Boolean) }
    def empty?
      @state.empty?
    end

    sig { params(uri: URI::Generic).void }
    def delete(uri)
      @state.delete(uri.to_s)
    end

    sig do
      type_parameters(:T)
        .params(
          uri: URI::Generic,
          request_name: String,
          block: T.proc.params(document: Document).returns(T.type_parameter(:T)),
        ).returns(T.type_parameter(:T))
    end
    def cache_fetch(uri, request_name, &block)
      get(uri).cache_fetch(request_name, &block)
    end
  end
end
