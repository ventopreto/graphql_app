require "rails_helper"
require "devise/jwt/test_helpers"

RSpec.describe "Policy", type: :request do
  context "Mutation policy" do
    let(:query_string) do
      <<-GRAPHQL
      query($id: ID!) {
        getPolicy(id: $id) {
          insured{
            cpf
            name
            }
          }
        }
      GRAPHQL
    end

    let(:response) do
      double(Faraday::Response, status: 200, body: "{\"payload\":{\"policy_id\":3,\"start_date_coverage\":\"1969-01-10\",\"end_date_coverage\":\"2030-01-10\",\"insured\":{\"name\":\"Bo Duke\",\"cpf\":\"23456789012\"},\"vehicle\":{\"brand\":\"Dodge\",\"model\":\"Charger\",\"year\":\"1969\",\"registration_plate\":\"General Lee\"}}}")
    end

    context "when not authenticated" do
      it "raise an error saying Not Authenticated" do
        result = MyappSchema.execute(query_string, context: {authenticated?: false}, variables: {id: 1})

        expect(result["errors"].first["message"]).to eq("Not Authenticated")
      end
    end

    context "when authenticated and valid" do
      before { allow(Faraday).to receive(:get).and_return(response) }

      it "raise an error saying Not Authenticated" do
        result = MyappSchema.execute(query_string, context: {authenticated?: true}, variables: {id: 3})

        expect(result["data"]["getPolicy"]["insured"]["cpf"]).to eq("23456789012")
        expect(result["data"]["getPolicy"]["insured"]["name"]).to eq("Bo Duke")
      end
    end
  end
end
