class AddMimeEncoding < ActiveRecord::Migration[5.1]
  def change
    add_column :mock_responses, :response_mime_type, :string
    add_column :mock_responses, :response_encoding, :string
  end
end
