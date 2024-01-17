class ChangeSchemaV2 < ActiveRecord::Migration[6.0]
  def change
    create_table :audit_logs, comment: 'Stores logs for auditing purposes' do |t|
      t.string :action

      t.string :entity_type

      t.integer :entity_id

      t.datetime :timestamp

      t.timestamps null: false
    end

    change_table_comment :todos, from: 'Stores todo items created by users', to: 'Stores the To-Do items for users'

    add_column :users, :password_hash, :string

    add_column :users, :email, :string

    add_column :users, :username, :string

    add_column :todos, :is_completed, :boolean

    add_reference :audit_logs, :user, foreign_key: true
  end
end
