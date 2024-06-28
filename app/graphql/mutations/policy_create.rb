# frozen_string_literal: true

module Mutations
  class PolicyCreate < BaseMutation
    description "Creates a new policy"

    field :message, String, null: false

    argument :policy_input, Types::PolicyInputType, required: true

    def resolve(policy_input:)
      Producer.publish(policy_input)
      {
        message: "Policy created"
      }
    end
  end
end
