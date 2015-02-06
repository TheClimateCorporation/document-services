require 'rails_helper'

RSpec.describe MessageBus do

  describe "#publish" do
    before do
      stub_request(:post, "http://message-bus.net/messages")
    end

    context "when STUB_PUBLISHING is true" do
      before do
        MessageBus::STUB_PUBLISHING = 'true'
      end

      it "doesn't do anything" do
        expect(MessageBus.publish("sojourner.rspec-test", "demo", { document_id: 1 }))
          .to eq(true)
      end
    end

    context "when STUB_PUBLISHING is false" do
      before do
        MessageBus::STUB_PUBLISHING = 'false'
      end

      it "publishes a message given a routing key, exchange, and message" do
        MessageBus.publish("sojourner.rspec-test", "demo", { document_id: 1 })
        expect(
          a_request(:post, "http://message-bus.net/messages")
            .with(:body => '{"routing_key":"sojourner.rspec-test","exchange":"demo","data":"{\"document_id\":1}"}')
        ).to have_been_made
      end
    end
  end
end
