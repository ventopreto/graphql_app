require "rails_helper"
require "bunny-mock"

RSpec.describe ProducerPolicyCreated do
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

    it "confirms message delivery" do
      exchange.publish(message, persistent: true)

      expect(channel.wait_for_confirms).to be true
    end
  end

  describe ".publish_message" do
    context "when message is confirmed" do
      it "returns a success message" do
        result = described_class.publish_message(exchange, message)

        expect(result).to eq({message: "Policy created"})
      end
    end

    context "when message delivery fails" do
      before do
        allow_any_instance_of(BunnyMock::Channel).to receive(:wait_for_confirms).and_raise(Bunny::Exception)
      end

      it "returns a failure message" do
        result = described_class.publish_message(exchange, message)

        expect(result).to eq({message: "Policy not created"})
      end
    end
  end

  describe ".channel" do
    it "creates a new channel" do
      expect(described_class.channel).to be_a(BunnyMock::Channel)
    end
  end

  describe ".connection" do
    it "creates a new connection" do
      expect(described_class.connection).to be_a(BunnyMock::Session)
    end
  end
end
