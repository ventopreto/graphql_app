# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :policy_create, mutation: Mutations::PolicyCreate
  end
end
