class CreateLinkTos < ActiveRecord::Migration
  def change
    create_table :link_tos do |t|
      t.string :title
      t.string :description
      t.text :url
      t.string :link_text
      t.string :icon_style
      t.string :panel_style

      t.timestamps null: false
    end
  end
end
