module Api::V1
  class ReportDetailSerializer < ActiveModel::Serializer
    attributes :id, :title, :completion_status, :attempt_type, :completion_date, :start_date, :game_theme_fields
    has_one :game_holder, serializer: GameHolderDetailSerializer
    has_many :game_sessions, serializer: GameSessionSerializer
    def creation_date
      object.created_at.strftime("%d/%m/%y")
    end

    def game_theme_fields
      object.game_theme.theme_fields if !object.game_theme.nil?
    end
  end
end
