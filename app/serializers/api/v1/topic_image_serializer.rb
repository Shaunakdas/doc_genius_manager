module Api::V1
  class TopicImageSerializer < AcadEntitySerializer
    attributes :image_slug, :sequence
    def image_slug
      cards = VictoryCard.where(acad_entity: object.practice_game_holders.last)
      return nil if cards.length == 0
      return cards.first.slug
    end
  end
end
