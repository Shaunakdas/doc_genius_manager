module Api::V1::PracticeQuestions
  class DivisionQuestionSerializer < PracticeQuestionSerializer
    attributes :id, :mode, :_mode,:question, :answer, :hint, :options

    def _mode
      "addition_roman_left,addition_roman_right,multiplication_long,multiple_addition,addition_algebra,multiplication_factor_exponent,"
    end
    def options
      ActiveModel::ArraySerializer.new(object.game_options, each_serializer: DivisionOptionSerializer)
    end
  end
end