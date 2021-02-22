module Api::V1
  class ReportSerializer < ActiveModel::Serializer
    attributes :id, :title, :completion_status, :attempt_type, :completion_date, :start_date, :creation_date, :session_count
    has_one :game_holder, serializer: GameHolderSerializer    
    def creation_date
      object.created_at.strftime("%d/%m/%y")
    end

    def session_count
      object.game_sessions.length
    end

  end
end
