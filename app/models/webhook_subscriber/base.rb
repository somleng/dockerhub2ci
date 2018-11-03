class WebhookSubscriber::Base
  delegate :tag_mappings, :tag_passthrough?, :repo_mappings, :to => :class

  DEFAULT_TAG_MAPPINGS = {
    "latest" => "master"
  }

  def webhook_received!(payload)
    WebhookJob.perform_later(self.class.to_s, payload)
  end

  private

  def self.tag_mappings
    DEFAULT_TAG_MAPPINGS.merge(env_tag_mappings)
  end

  def self.tag_passthrough?
    env_tag_passthrough?
  end

  def self.repo_mappings
    env_repo_mappings
  end

  def self.env_tag_mappings
    parse_key_value_pairs(ENV["TAG_MAPPINGS"])
  end

  def self.env_tag_passthrough?
    ENV["DISABLE_TAG_PASSTHROUGH"].to_i.zero?
  end

  def self.env_repo_mappings
    parse_key_value_pairs(ENV["REPO_MAPPINGS"])
  end

  def self.parse_key_value_pairs(key_value_pairs)
    Hash[key_value_pairs.to_s.split(";").map { |key_value| key_value.split("=") }]
  end
end
