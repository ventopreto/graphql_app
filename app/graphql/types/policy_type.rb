# frozen_string_literal: true

module Types
  class PolicyType < Types::BaseObject
    field :id, ID, null: false
    field :start_date_coverage, GraphQL::Types::ISO8601DateTime
    field :end_date_coverage, GraphQL::Types::ISO8601DateTime
    field :created_at, GraphQL::Types::ISO8601DateTime
    field :updated_at, GraphQL::Types::ISO8601DateTime
    field :insured_id, ID, null: false
  end
end
