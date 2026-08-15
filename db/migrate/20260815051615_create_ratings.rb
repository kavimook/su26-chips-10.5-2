# frozen_string_literal: true

class CreateRatings < ActiveRecord::Migration[7.2]
  def change
    create_table :ratings do |t|
      t.integer :score, null: false
      t.references :news_item, null: false
      t.references :user, null: false

      t.timestamps
    end

    add_index :ratings, %i[user_id news_item_id], unique: true
  end
end
