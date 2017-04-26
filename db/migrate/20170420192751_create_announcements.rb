class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :name
      t.string :announcement
      t.string :creator_id

      t.timestamps null: false
    end
  end
end
