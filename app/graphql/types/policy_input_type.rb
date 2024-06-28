# frozen_string_literal: true

module Types
  class PolicyInputType < Types::BaseInputObject
    argument :start_date_coverage, GraphQL::Types::ISO8601DateTime, required: true, camelize: false
    argument :end_date_coverage, GraphQL::Types::ISO8601DateTime, required: true, camelize: false
    argument :vehicle, Types::VehicleInputType, required: true
    argument :insured, InsuredInputType, required: true
  end
end
