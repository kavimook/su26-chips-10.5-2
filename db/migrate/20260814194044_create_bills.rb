class CreateBills < ActiveRecord::Migration[7.2]
  def change
    create_table :bills do |t|
      t.timestamps
    end
  end
end
