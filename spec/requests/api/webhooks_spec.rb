require 'rails_helper'

describe "Webhooks API" do
  def setup_scenario
    do_request
  end

  before do
    setup_scenario
  end

  def assert_response!
    expect(response.code).to eq(asserted_response_code)
  end

  describe "POST '/api/webhooks'" do
    include EnvHelpers

    let(:asserted_tag) { "latest" }
    let(:payload) { attributes_for(:webhook, :tag => asserted_tag)[:payload] }

    def do_request
      post(
        api_webhooks_path,
        :params => payload.to_json,
        :headers => {"CONTENT_TYPE" => "application/json"}
      )
    end

    context "webhooks are configured to be saved" do
      let(:asserted_response_code) { "201" }

      def setup_scenario
        stub_env(:save_webhooks => "1")
        super
      end

      def assert_response!
        super
        expect(Webhook.by_tag(asserted_tag)).to be_present
      end

      it { assert_response! }
    end

    context "webhooks are not configured to be saved" do
      let(:asserted_response_code) { "204" }

      it { assert_response! }
    end
  end

  describe "GET '/api/webhooks/:id'" do
    let(:webhook) { create(:webhook) }
    let(:asserted_response_code) { "200" }

    def do_request
      get(api_webhook_path(webhook))
    end

    it { assert_response! }
  end
end
