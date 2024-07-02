# frozen_string_literal: true

module Types
  class VehicleType < Types::BaseObject
    field :id, ID, null: false
    field :brand, String
    field :model, String
    field :year, Integer
    field :registration_plate, String
    # field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    # field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :policy_id, Integer, null: false
  end
end
