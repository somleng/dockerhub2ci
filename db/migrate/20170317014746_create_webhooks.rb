class CreateWebhooks < ActiveRecord::Migration[5.0]
  def change
    create_table :webhooks do |t|
      t.json :payload, :null => false
      t.timestamps
    end
  end
end
