class WebhookSubscriber::Travis < WebhookSubscriber::Base
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
      {"request" => {"branch" => branch, "config" => config}}.to_json
    end

    def requests_endpoint(repo_name)
      endpoint + "/repo/#{CGI.escape(repo_name)}/requests"
    end

    def config
      {
        "merge_mode" => "merge",
        "sudo" => "required",
        "env" => {
          "matrix" => ["DOCKER=1"]
        }
      }
    end
  end

  def perform!(payload)
    webhook = Webhook.new(:payload => payload)
    dockerhub_repo_name = webhook.repository_repo_name
    dockerhub_tag_name = webhook.push_data_tag
    build_repo_name = repo_mappings[dockerhub_repo_name] || dockerhub_repo_name
    build_branch_name = tag_mappings[dockerhub_tag_name] || dockerhub_tag_name
    Rails.logger.debug("Triggering Travis Build with repo: #{build_repo_name}, branch: #{build_branch_name}")
    response = travis_client.create_request!(build_repo_name, build_branch_name)
    Rails.logger.debug "Travis response: #{response}"
  end

  private

  def travis_client
    @travis_client ||= TravisClient.new
  end
end
