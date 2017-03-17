require 'rails_helper'

describe WebhookSubscriber::Travis do
  describe "#webhook_received!(payload)" do
    include ActiveJob::TestHelper

    let(:payload) { {"foo" => "bar"} }

    def setup_scenario
      clear_enqueued_jobs
      subject.webhook_received!(payload)
    end

    before do
      setup_scenario
    end

    def assert_webhook_received!
      expect(WebhookJob).to have_been_enqueued.with(described_class.to_s, payload)
    end

    it { assert_webhook_received! }
  end

  describe "#perform!(payload)" do
  end
end
