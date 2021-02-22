module Api::V1
  class GameHolderSummarySerializer < AcadEntitySerializer
    attributes :id, :title, :name, :slug, :game, :image_url, :enabled, :question_count, :standard, :creation_date,
      :creator_username, :creator_image_url, :like_flag, :save_flag
    has_one :game, serializer: GameSerializer

    def question_count
      object.game_questions.count
    end

    def standard
      return nil if object.acad_entity.nil?
      return object.acad_entity.chapter.standard.name if object.acad_entity.chapter.standard
    end
    
    def creation_date
      object.created_at.strftime("%d/%m/%y")
    end

    def creator_username
      return "shaunakdas2020_01126"
    end

    def creator_image_url
      return "https://lh3.googleusercontent.com/a-/AOh14Gj4BM8a_JfCdw2rHROch4yBa5MJFXJ-tTD64F8E3Q=s96-c?w=90&amp;h=90"
    end

    def like_flag
      false
    end

    def save_flag
      false
    end
  end
end
