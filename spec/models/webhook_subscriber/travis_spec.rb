require 'rails_helper'

describe WebhookSubscriber::Travis do
  include EnvHelpers

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

  describe "#perform!(payload)", :vcr, :cassette => "travis_create_request" do
    let(:tag) { "latest" }
    let(:travis_token) { "travis-token" }
    let(:repo_user) { "dwilkie" }
    let(:repo_name) { "dockerhub2ci" }
    let(:repo_path) { "#{repo_user}/#{repo_name}" }
    let(:payload) { create(:webhook, :push_data_tag => tag, :repository_repo_name => repo_path)[:payload] }

    let(:asserted_branch_name) { "master" }
    let(:asserted_content_type) { "application/json" }
    let(:asserted_api_version) { "3" }
    let(:asserted_host) { "api.travis-ci.org" }
    let(:asserted_path) { "/repo/#{repo_user}%2F#{repo_name}/requests" }
    let(:asserted_authorization) { "token #{travis_token}" }

    def env
      @env ||= {
        "travis_token" => travis_token
      }
    end

    let(:request) { WebMock.requests.last }
    let(:uri) { request.uri }
    let(:request_body) { JSON.parse(request.body) }
    let(:headers) { request.headers }
    let(:branch) { request_body["request"]["branch"] }

    def setup_scenario
      stub_env(env)
      subject.perform!(payload)
    end

    before do
      setup_scenario
    end

    def assert_perform!
      expect(branch).to eq(asserted_branch_name)
      expect(headers["Content-Type"]).to eq(asserted_content_type)
      expect(headers["Accept"]).to eq(asserted_content_type)
      expect(headers["Travis-Api-Version"]).to eq(asserted_api_version)
      expect(headers["Authorization"]).to eq(asserted_authorization)
      expect(uri.host).to eq(asserted_host)
      expect(uri.path).to eq(asserted_path)
    end

    it { assert_perform! }

    context "tag other than 'latest'" do
      let(:tag) { "some_tag" }
      let(:asserted_branch_name) { tag }

      it { assert_perform! }
    end

    context "with tag_mappings" do
      let(:tag) { "some_tag" }
      let(:branch_name) { "staging" }
      let(:asserted_branch_name) { branch_name }

      def env
        super.merge(:tag_mappings => "#{tag}=#{branch_name}")
      end

      it { assert_perform! }
    end
  end
end
