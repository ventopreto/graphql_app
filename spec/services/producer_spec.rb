require "rails_helper"
require "bunny-mock"

RSpec.describe Producer do
  let(:connection) { BunnyMock.new }
  let(:channel) { connection.create_channel }
  let(:exchange) { channel.fanout("policy_created") }
  let(:message) do
    {
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
    }
  end

  before do
    allow(Bunny).to receive(:new).and_return(connection)
  end

  describe ".publish" do
    it "publishes a message to the policy_created exchange" do
      described_class.publish(message)

      expect(exchange.name).to eq("policy_created")
      expect(exchange.opts[:type]).to eq(:fanout)
    end
  end

  describe ".channel" do
    it "creates a new channel" do
      expect(described_class.channel).to be_a(Bunny::Channel)
    end
  end

  describe ".connection" do
    it "creates a new connection" do
      expect(described_class.connection).to be_a(BunnyMock::Session)
    end
  end
end
