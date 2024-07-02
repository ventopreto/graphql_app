require "bunny"

class Producer
  class << self
    def publish(message = {})
      extrange = channel.fanout("policy_created")
      channel.confirm_select
      publish_message(extrange, message.to_json)
    end

    def publish_message(exchange, message)
      exchange.publish(message, persistent: true)
      {message: "Policy created"} if channel.wait_for_confirms
    rescue Bunny::Exception
      {message: "Policy not created"}
    end

    def channel
      @channel ||= connection.create_channel
    end

    def connection
      Bunny.new(host: "rabbitmq", user: "user", pass: "password").start
    end
  end
end
