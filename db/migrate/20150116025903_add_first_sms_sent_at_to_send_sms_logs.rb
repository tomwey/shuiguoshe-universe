class AddFirstSmsSentAtToSendSmsLogs < ActiveRecord::Migration
  def change
    add_column :send_sms_logs, :first_sms_sent_at, :datetime
  end
end
