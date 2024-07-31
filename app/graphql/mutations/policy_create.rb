# frozen_string_literal: true

module Mutations
  class PolicyCreate < BaseMutation
    description "Creates a new policy"

    field :message, String, null: false

    argument :policy_input, Types::PolicyInputType, required: true

    def resolve(policy_input:)
      ProducerPolicyCreated.publish(policy_input)
    end

    def self.authorized?(obj, context)
      super && if context[:authenticated?]
        true
      else
        raise GraphQL::ExecutionError, "Not Authenticated"
      end
    end
  end
end
