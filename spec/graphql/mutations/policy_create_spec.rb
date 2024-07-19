require "rails_helper"
require "devise/jwt/test_helpers"

RSpec.describe "Policy", type: :request do
  context "Mutation policy" do
    let(:query_string) do
      <<-GRAPHQL
            mutation($vehicle: VehicleInput!, $insured: InsuredInput!, $start_date_coverage: ISO8601DateTime!, $end_date_coverage: ISO8601DateTime! ) {
              policyCreate(input: {policyInput: {
                vehicle: $vehicle
                insured: $insured
                start_date_coverage: $start_date_coverage
                end_date_coverage: $end_date_coverage
                }
              }
              ) {
                message
              }
            }
      GRAPHQL
    end

    context "when not authenticated" do
      it "raise an error saying Not Authenticated" do
        result = MyappSchema.execute(query_string, context: {authencicated?: false}, variables: {
          start_date_coverage: "1994-10-05",
          end_date_coverage: "1998-11-10",
          vehicle: {
            brand: "Ford",
            model: "Falcon GT",
            year: "1973",
            registration_plate: "Interceptor-v6"
          },
          insured: {
            name: "Mad Max",
            cpf: "96151218000"
          }
        })

        expect(result["errors"].first["message"]).to eq("Not Authenticated")
      end
    end

    context "when authenticated and valid" do
      it "create a policy" do
        result = MyappSchema.execute(query_string, context: {authencicated?: true}, variables: {
          start_date_coverage: "1994-10-05",
          end_date_coverage: "1998-11-10",
          vehicle: {
            brand: "Ford",
            model: "Falcon GT",
            year: "1973",
            registration_plate: "Interceptor-v6"
          },
          insured: {
            name: "Mad Max",
            cpf: "96151218000"
          }
        })

        expect(result["data"]["policyCreate"]["message"]).to eq("Policy created")
      end
    end

    context "when vehicle argument is missing or invalid" do
      it "raise an error about vehicle invalid" do
        result = MyappSchema.execute(query_string, variables: {})

        expected_message = "Variable $vehicle of type VehicleInput! was provided invalid value"

        expect(result["errors"].first["message"]).to eq(expected_message)
      end
    end

    context "when insured argument is missing or invalid" do
      it "raise an error about insured invalid" do
        result = MyappSchema.execute(query_string, variables: {
          vehicle: {
            brand: "Ford",
            model: "Falcon GT",
            year: "1973",
            registration_plate: "Interceptor-v6"
          }
        })

        expected_message = "Variable $insured of type InsuredInput! was provided invalid value"

        expect(result["errors"].first["message"]).to eq(expected_message)
      end
    end

    context "when start_date_coverage argument is missing or invalid" do
      it "raise an error about start_date_coverage invalid" do
        result = MyappSchema.execute(query_string, variables: {
          vehicle: {
            brand: "Ford",
            model: "Falcon GT",
            year: "1973",
            registration_plate: "Interceptor-v6"
          },
          insured: {
            name: "Mad Max",
            cpf: "96151218000"
          }
        })

        expected_message = "Variable $start_date_coverage of type ISO8601DateTime! was provided invalid value"

        expect(result["errors"].first["message"]).to eq(expected_message)
      end
    end

    context "when end_date_coverage argument is missing or invalid" do
      it "raise an error about end_date_coverage invalid" do
        result = MyappSchema.execute(query_string, variables: {
          vehicle: {
            brand: "Ford",
            model: "Falcon GT",
            year: "1973",
            registration_plate: "Interceptor-v6"
          },
          insured: {
            name: "Mad Max",
            cpf: "96151218000"
          },
          start_date_coverage: "1985-04-12"
        })

        expected_message = "Variable $end_date_coverage of type ISO8601DateTime! was provided invalid value"

        expect(result["errors"].first["message"]).to eq(expected_message)
      end
    end
  end
end
