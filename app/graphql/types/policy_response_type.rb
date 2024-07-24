# frozen_string_literal: true

module Types
  class PolicyResponseType < Types::BaseObject
    field :policy, Types::PolicyType
    field :vehicle, Types::VehicleType
    field :insured, Types::InsuredType
  end
end
