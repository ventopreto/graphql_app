# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false, description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end

    field :get_policy, Types::PolicyResponseType, null: false, description: "Fetch policy for some id" do
      argument :id, ID, required: true
    end

    def get_policy(id:)
      headers = {Authorization: "Bearer #{context[:token]}"}
      response = Faraday.get("http://rest_app:3001/api/v1/policy/#{id}", nil, headers)
      parsed_response(response)
    end

    def self.authorized?(obj, context)
      super && if context[:authenticated?]
        true
      else
        raise GraphQL::ExecutionError, "Not Authenticated"
      end
    end

    private

    def parsed_response(response)
      return response.body if response.status == 401
      json = JSON.parse(response.body, symbolize_names: true)[:payload]
      json[:policy] = {id: json.delete(:policy_id), end_date_coverage: json.delete(:end_date_coverage), start_date_coverage: json.delete(:start_date_coverage)}
      json
    end
  end
end
