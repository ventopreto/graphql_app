require "bunny"

class ProducerPolicyCreated
  class << self
    def publish(message = {})
      exchange = channel.fanout("sneakers", durable: true)
      channel.confirm_select
      publish_message(exchange, message.to_json)
    end

    def publish_message(exchange, message)
      exchange.publish(message, persistent: true, routing_key: "policy_created")
      {message: "Policy created"} if channel.wait_for_confirms
    rescue Bunny::Exception
      {message: "Policy not created"}
    end

    def channel
      @channel ||= begin
        puts "Creating channel"
        connection.create_channel
      rescue Bunny::Exception => e
        puts "Error creating channel: #{e.message}"
        nil
      end
    end

    def connection
      @connection ||= begin
        puts "Creating connection"
        Bunny.new(host: "rabbitmq", user: "user", password: "password").start
      rescue Bunny::Exception => e
        puts "Error creating connection: #{e.message}"
        nil
      end
    end
  end
end
