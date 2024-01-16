class ChangeSchemaV1 < ActiveRecord::Migration[6.0]
  def change
    create_table :todos, comment: 'Stores todo items created by users' do |t|
      t.string :category

      t.integer :recurrence, default: 0

      t.string :title

      t.boolean :is_recurring

      t.integer :priority, default: 0

      t.text :description

      t.datetime :due_date

      t.timestamps null: false
    end

    create_table :users, comment: 'Stores user account information' do |t|
      t.string :name

      t.timestamps null: false
    end

    create_table :attachments, comment: 'Stores attachments related to todo items' do |t|
      t.timestamps null: false
    end

    add_reference :attachments, :todo, foreign_key: true

    add_reference :todos, :user, foreign_key: true
  end
end
