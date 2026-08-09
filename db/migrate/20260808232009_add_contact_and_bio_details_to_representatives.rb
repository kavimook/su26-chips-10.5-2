class AddContactAndBioDetailsToRepresentatives < ActiveRecord::Migration[7.2]
  def change
    add_column :representatives, :phone, :string
    add_column :representatives, :website, :string
    add_column :representatives, :twitter, :string
    add_column :representatives, :facebook, :string
    add_column :representatives, :birthday, :string
    add_column :representatives, :gender, :string
  end
end
