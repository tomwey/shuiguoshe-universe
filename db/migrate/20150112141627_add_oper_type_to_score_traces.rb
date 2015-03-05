class AddOperTypeToScoreTraces < ActiveRecord::Migration
  def change
    add_column :score_traces, :oper_type, :string
  end
end
