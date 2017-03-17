require 'rails_helper'

describe WebhookJob do
  describe "#perform(subscriber_class, payload)" do
    let(:subscriber_class) { WebhookSubscriber::Travis }
    let(:subscriber) { object_double(subscriber_class.new) }
    let(:payload) { {"foo" => "bar"} }

    def assert_perform!
      allow(subscriber_class).to receive(:new).and_return(subscriber)
      allow(subscriber).to receive(:perform!)
      expect(subscriber_class).to receive(:new)
      expect(subscriber).to receive(:perform!).with(payload)
      subject.perform(subscriber_class.to_s, payload)
    end

    it { assert_perform! }
  end
end
