module Api::V1
  class ChaptersController < ApiController
    before_action :authenticate_request!, only: [ :index, :list ]
    respond_to :json
    # GET /api/v1/standards
    def index
      list_response = Chapter.list(params)
      respond_with list_response[:result], each_serializer: Api::V1::ChapterOptionSerializer, meta: list_response.except!(:result), location: '/standard'
    end

    def list
      if @current_user
        puts @current_user
        respond_with @current_user.enabled_chapters, each_serializer: Api::V1::ChapterTopicSerializer, location: '/standards'
      else
        error_response("Auth Token is not valid") 
      end
      
    end
  end
end
