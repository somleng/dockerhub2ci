class Webhook < ApplicationRecord
  def self.by_tag(tag)
    where("payload#>>'{push_data, tag}' = ?", tag)
  end
end
