class CreateSendSmsLogs < ActiveRecord::Migration
  def change
    create_table :send_sms_logs do |t|
      t.string :mobile
      t.integer :send_type
      t.integer :sms_total, default: 0

      t.timestamps
    end
  end
end
