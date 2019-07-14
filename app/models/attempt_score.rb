class AttemptScore < ApplicationRecord
  belongs_to :attempt_item, polymorphic: true

  def total_value
    normal_marks + (speedy_marks || 0) + (complete_set_marks || 0) + (actual_answer_marks || 0) + (consistency_marks || 0) + (remaining_time_marks || 0) + (remaining_lives_marks || 0)
  end
end
