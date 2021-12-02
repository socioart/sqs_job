require "securerandom"
require "json"

module SqsJob
  class Job
    attr_reader :id, :manager_id, :name, :attributes

    # @param [Hash] h
    def self.deserialize(h)
      new(
        h.fetch("name"),
        h.fetch("attributes"),
        manager_id: h.fetch("manager_id"),
        id: h.fetch("id"),
      )
    end

    def initialize(name, attributes, manager_id:, id: SecureRandom.uuid)
      @id = id
      @manager_id = manager_id
      @name = name
      @attributes = attributes
    end

    def as_json
      {
        id: id,
        manager_id: manager_id,
        name: name,
        attributes: attributes,
      }
    end

    def to_json(*args)
      as_json.to_json(*args)
    end
  end
end
