class ScoreTrace < ActiveRecord::Base
  def as_json(opts = {})
    {
      id: self.id,
      oper_type: self.oper_type || "",
      score: self.score,
      summary: self.summary || "",
      created_at: self.created_at.strftime("%Y-%m-%d %H:%M:%S")
    }
  end
end


# == Schema Information
#
# Table name: score_traces
#
#  id         :integer          not null, primary key
#  score      :integer
#  summary    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#