class MessageBus

  STUB_PUBLISHING = DotProperties.fetch('message_bus.stub_publishing') { 'true' }

  def self.publish(routing_key, exchange, message)
    return true if STUB_PUBLISHING == 'true'

    begin
      connection.post('messages', {
        routing_key: routing_key,
        exchange: exchange,
        data: message.to_json
      })
    rescue ArgumentError, Faraday::Error => err
      # TODO: implement handling of failed publish methods
    end
  end

  private

  def self.connection
    @connection  ||= Faraday.new(:url => MESSAGE_BUS_CONFIG["uri"]) do |faraday|
      faraday.request  :json
      faraday.response :raise_error
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

end
