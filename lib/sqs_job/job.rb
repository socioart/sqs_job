require "securerandom"
require "json"

module SqsJob
  class Job
    attr_reader :id, :name, :attributes

    # @param [Hash] h
    def self.deserialize(h)
      new(
        h.fetch("name"),
        h.fetch("attributes"),
        id: h.fetch("id"),
      )
    end

    def initialize(name, attributes, id: SecureRandom.uuid)
      @id = id
      @name = name
      @attributes = attributes
    end

    def as_json
      {
        id: id,
        name: name,
        attributes: attributes,
      }
    end

    def to_json(*args)
      as_json.to_json(*args)
    end
  end
end
