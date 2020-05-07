module Api::V1
  class VictoryCardsController < ApplicationController
    respond_to :json
    # GET /api/v1/victory_cards
    def index
      victory_cards = VictoryCard.order("id ASC")
      respond_with victory_cards, each_serializer: Api::V1::VictoryCardSerializer, location: '/victory_cards'
    end
  end
end