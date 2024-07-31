require "bunny"

class ProducerPolicyPaid
  class << self
    def publish(message = {})
      exchange = channel.fanout("sneakers", durable: true)
      channel.confirm_select
      publish_message(exchange, message.to_json)
    end

    def publish_message(exchange, message)
      exchange.publish(message, persistent: true, routing_key: "policy_paid")
      {message: "Policy Paid"} if channel.wait_for_confirms
    rescue Bunny::Exception
      {message: "Policy not Paid"}
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
        Bunny.new(host: "rabbitmq", user: "user", pass: "password").start
      end
    rescue Bunny::Exception => e
      puts "Error creating connection: #{e.message}"
      nil
    end
  end
end
