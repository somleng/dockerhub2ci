require 'rails_helper'

describe "Webhooks API" do
  include EnvHelpers

  let(:api_key) { "SOME-API-KEY" }
  let(:request_headers) { {} }
  let(:headers) { authorization_headers.merge(request_headers) }

  def env
    @env ||= {
      :api_keys => api_key
    }
  end

  def authorization_headers
    @authorization_headers ||= {
      "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials(api_key, "")
    }
  end

  def setup_scenario
    stub_env(env)
    do_request
  end

  before do
    setup_scenario
  end

  def assert_response!
    expect(response.code).to eq(asserted_response_code)
  end

  describe "POST '/api/webhooks'" do
    let(:asserted_tag) { "latest" }
    let(:payload) { attributes_for(:webhook, :tag => asserted_tag)[:payload] }
    let(:params) { payload.to_json }
    let(:request_headers) { { "CONTENT_TYPE" => "application/json" } }
    let(:asserted_response_code) { "201" }

    def do_request
      post(
        api_webhooks_path,
        :params => params,
        :headers => headers
      )
    end

    context "unauthorized request" do
      let(:authorization_headers) { {} }
      let(:asserted_response_code) { "401" }
      it { assert_response! }
    end

    context "webhooks are configured to be saved" do
      def env
        super.merge(:save_webhooks => "1")
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

    context "subscribers are registered" do
      include ActiveJob::TestHelper
      let(:subscriber_class) { WebhookSubscriber::Travis }

      def setup_scenario
        subscriber_class
        clear_enqueued_jobs
        super
      end

      def env
        super.merge(:webhook_subscribers => subscriber_class.to_s)
      end

      def assert_response!
        expect(WebhookJob).to have_been_enqueued
      end

      it { assert_response! }
    end

    context "invalid request" do
      let(:params) { {} }
      let(:asserted_response_code) { "422" }
      it { assert_response! }
    end
  end

  describe "GET '/api/webhooks/:id'" do
    let(:webhook) { create(:webhook) }
    let(:asserted_response_code) { "200" }

    def do_request
      get(api_webhook_path(webhook), :headers => headers)
    end

    it { assert_response! }

    context "unauthorized request" do
      let(:authorization_headers) { {} }
      let(:asserted_response_code) { "401" }

      it { assert_response! }
    end
  end
end
