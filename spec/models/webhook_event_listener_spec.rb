require 'rails_helper'

describe WebhookEventListener do
  describe ".webhook_subscribers" do
    include EnvHelpers

    def env
      @env ||= {}
    end

    def setup_scenario
      stub_env(env)
      WebhookSubscriber::Travis # eager load constants
    end

    before do
      setup_scenario
    end

    def assert_webhook_subscribers!
      expect(described_class.webhook_subscribers).to match_array(asserted_webhook_subscribers)
    end

    context "no registered subscribers" do
      let(:asserted_webhook_subscribers) { [] }
      it { assert_webhook_subscribers! }
    end

    context "with registered subscribers" do
      def env
        super.merge(
          :webhook_subscribers => "WebhookSubscriber::Travis"
        )
      end

      let(:asserted_webhook_subscribers) { [WebhookSubscriber::Travis] }
      it { assert_webhook_subscribers! }
    end
  end
end
