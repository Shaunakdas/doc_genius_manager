module Api::V1::PracticeQuestions
  class InversionContentSerializer < PracticeContentSerializer
    attributes :id, :title, :sub_title

    def options
      object.game_options.map{|x|x.option.display}
    end

    def title
      options.first
    end

    def sub_title
      options[1]
    end
  end
end