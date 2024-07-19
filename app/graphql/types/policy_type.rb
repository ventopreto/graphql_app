# frozen_string_literal: true

module Types
  class PolicyType < Types::BaseObject
    field :id, ID, null: false
    field :start_date, GraphQL::Types::ISO8601DateTime, null: false
    field :end_date, GraphQL::Types::ISO8601DateTime, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime
    field :updated_at, GraphQL::Types::ISO8601DateTime
    field :insured_id, ID, null: false
  end
end
