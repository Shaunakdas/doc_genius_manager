module Api::V1
  class GameThemeSerializer < ActiveModel::Serializer
    attributes :id, :title, :payload, :saved

    def saved
      if !scope.nil? && !scope[:user_id].nil?
        u = User.find(scope[:user_id])
        return true if u && (u.saved_game_themes.where(id: object.id).count > 0)
      end
      return false
    end
  end
end