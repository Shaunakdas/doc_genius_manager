module Api::V1
  class ChaptersController < ApplicationController
    respond_to :json
    # GET /api/v1/standards
    def index
      list_response = Chapter.list(params)
      respond_with list_response[:result], each_serializer: Api::V1::ChapterOptionSerializer, meta: list_response.except!(:result), location: '/standard'
    end
  end
end
