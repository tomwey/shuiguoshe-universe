class CreateScoreTraces < ActiveRecord::Migration
  def change
    create_table :score_traces do |t|
      t.integer :score
      t.string :summary
      t.integer :user_id

      t.timestamps
    end
    add_index :score_traces, :user_id
  end
end
