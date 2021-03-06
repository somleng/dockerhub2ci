class Webhook < ApplicationRecord
  include Wisper::Publisher

  attr_accessor :push_data

  validates :push_data, :presence => true

  def self.by_tag(tag)
    where("payload#>>'{push_data, tag}' = ?", tag)
  end

  def push_data
    payload_attribute("push_data")
  end

  def repository
    payload_attribute("repository")
  end

  def push_data_tag
    push_data["tag"]
  end

  def repository_repo_name
    repository["repo_name"]
  end

  def broadcast_received!
    broadcast(:webhook_received, payload)
  end

  private

  def payload_attribute(attribute)
    (payload || {})[attribute]
  end
end
