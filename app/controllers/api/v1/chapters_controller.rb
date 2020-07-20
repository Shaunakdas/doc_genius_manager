module Api::V1
  class ChaptersController < ApiController
    before_action :authenticate_request!, only: [ :topicwise_levels, :list ]
    respond_to :json
    # GET /api/v1/standards
    def index
      list_response = Chapter.list(params)
      respond_with list_response[:result], each_serializer: Api::V1::ChapterOptionSerializer, meta: list_response.except!(:result), location: '/standard'
    end

    def list
      if @current_user
        meta = nil
        recent_level = @current_user.level_standing
        if recent_level
          meta = {
            title: recent_level.acad_entity.title,
            date: @current_user.last_attempt_time
          }
        end
        respond_with @current_user.enabled_chapters, each_serializer: Api::V1::ChapterTopicSerializer, meta: meta, location: '/standards'
      else
        error_response("Auth Token is not valid") 
      end
      
    end

    def topicwise_levels
      jump = false
      if @current_user
        begin
          if !params[:topic_id].nil?
            topic = Topic.find(params[:topic_id])
            topic.set_fresh_standing(@current_user)
          else
            topic = @current_user.topic_standing.acad_entity
            jump = topic.reset_jump(@current_user)
          end
          scope = {
            topic_id: topic.id,
            jump: jump
          }
          respond_with Api::V1::TopicwiseSerializer.new(@current_user, {scope: scope})
        rescue ActiveRecord::RecordNotFound
          error_response("Couldn't find Topic with 'id'=#{params[:topic_id]}", :not_found) 
        end
      else
        error_response("Auth Token is not valid") 
      end
    end
  end
end
