require "bunny"

class Producer
  class << self
    def publish(message = {})
      extrange = channel.fanout("policy_created")
      extrange.publish(message.to_json)
    end

    def channel
      @channel ||= connection.create_channel
    end

    def connection
      Bunny.new(host: "rabbitmq", user: "user", pass: "password").start
    end
  end
end
