module Api::V1
  class ReportDetailSerializer < ActiveModel::Serializer
    attributes :id, :title, :completion_status, :attempt_type, :completion_date, :start_date
    has_one :game_holder, serializer: GameHolderDetailSerializer
    has_many :game_sessions, serializer: GameSessionSerializer
  end
end
