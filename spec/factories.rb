FactoryGirl.define do
  factory :webhook do
    transient do
      tag "latest"
    end

    payload { JSON.parse("{\"push_data\": {\"pushed_at\": 1489720762, \"images\": [], \"tag\": \"#{tag}\", \"pusher\": \"dwilkie\"}, \"callback_url\": \"https://registry.hub.docker.com/u/dwilkie/dockerhub2ci/hook/2e1j5ejj452f34d51cd2hjgdbdi35ji4c/\", \"repository\": {\"status\": \"Active\", \"description\": \"Trigger CI when your dockerhub build finishes\", \"is_trusted\": true, \"full_description\": \"# README\\n\\nThis README would normally document whatever steps are necessary to get the\\napplication up and running.\\n\\nThings you may want to cover:\\n\\n* Ruby version\\n\\n* System dependencies\\n\\n* Configuration\\n\\n* Database creation\\n\\n* Database initialization\\n\\n* How to run the test suite\\n\\n* Services (job queues, cache servers, search engines, etc.)\\n\\n* Deployment instructions\\n\\n* ...\\n\", \"repo_url\": \"https://hub.docker.com/r/dwilkie/dockerhub2ci\", \"owner\": \"dwilkie\", \"is_official\": false, \"is_private\": false, \"name\": \"dockerhub2ci\", \"namespace\": \"dwilkie\", \"star_count\": 0, \"comment_count\": 0, \"date_created\": 1489715619, \"dockerfile\": \"FROM scratch\\nMAINTAINER dwilkie <dwilkie@gmail.com>\\n\\n# Dummy Dockerfile\\n\", \"repo_name\": \"dwilkie/dockerhub2ci\"}}") }
  end
end
