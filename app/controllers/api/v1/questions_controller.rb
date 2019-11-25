module Api::V1
  class QuestionsController < ApplicationController
    before_action :authenticate_request!, :only => [ :show ]
    respond_to :json
    # PUT /api/v1/question/update
    def update
      if params[:entity_id]
        begin
          case params[:entity_type]
          when "game_question"
            entity = GameQuestion.find(params[:entity_id])
          when "game_option"
            entity = GameOption.find(params[:entity_id])
          when "hint"
            entity = Hint.find(params[:entity_id])
          default
            entity = HintContent.find(params[:entity_id])
          end
          entity.update_content(params) if !entity.nil?
          render json: entity.details
        rescue ActiveRecord::RecordNotFound
          error_response("Couldn't find #{params[:entity_type]} with 'id'=#{params[:entity_id]}", :not_found) 
        rescue ActiveRecord::RecordInvalid => invalid
          error_response(entity.errors.full_messages[0], :unprocessable_entity) 
        end
      else
        error_response("No entity_id is present") 
      end
    end
  end
end
