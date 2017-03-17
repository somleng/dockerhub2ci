class WebhookSubscriber::Travis < WebhookSubscriber::Base
  delegate :tag_mappings, :to => :class

  DEFAULT_TAG_MAPPINGS = {
    "latest" => "master"
  }

  class TravisClient
    TRAVIS_ORG_ENDPOINT = "https://api.travis-ci.org"
    TRAVIS_PRO_ENDPOINT = "https://api.travis-ci.com"
    TRAVIS_CONTENT_TYPE = "application/json"
    TRAVIS_API_VERSION  = "3"

    attr_accessor :token, :endpoint, :content_type, :api_version

    def initialize(options = {})
      self.token = options[:token] || ENV["TRAVIS_TOKEN"]
      self.endpoint = options[:travis_endpoint] || ENV["TRAVIS_ENDPOINT"] || TRAVIS_ORG_ENDPOINT
      self.content_type = options[:content_type] || ENV["TRAVIS_CONTENT_TYPE"] || TRAVIS_CONTENT_TYPE
      self.api_version = options[:api_version] || ENV["TRAVIS_API_VERSION"] || TRAVIS_API_VERSION
    end

    def create_request!(repo_name, branch)
      HTTParty.post(
        requests_endpoint(repo_name),
        :body => request_body(branch),
        :headers => request_headers
      )
    end

    private

    def request_headers
      {
        "Content-Type" => content_type,
        "Accept" => content_type,
        "Travis-API-Version" => api_version,
        "Authorization" => "token #{token}"
      }
    end

    def request_body(branch)
      {"request" => {"branch" => branch}}.to_json
    end

    def requests_endpoint(repo_name)
      endpoint + "/repo/#{CGI.escape(repo_name)}/requests"
    end
  end

  def perform!(payload)
    webhook = Webhook.new(:payload => payload)
    repo_name = webhook.repository_repo_name
    tag_name = webhook.push_data_tag
    branch_name = tag_mappings[tag_name] || tag_name
    Rails.logger.debug("Triggering Travis Build with repo: #{repo_name}, branch: #{branch_name}")
    response = travis_client.create_request!(repo_name, branch_name)
    Rails.logger.debug "Travis response: #{response}"
  end

  private

  def self.tag_mappings
    DEFAULT_TAG_MAPPINGS.merge(env_tag_mappings)
  end

  def self.env_tag_mappings
    Hash[ENV["TAG_MAPPINGS"].to_s.split(";").map { |key_value| key_value.split("=") }]
  end

  def travis_client
    @travis_client ||= TravisClient.new
  end
end
