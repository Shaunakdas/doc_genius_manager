module Api::V1
  class QuestionsController < ApiController
    before_action :authenticate_request!, :only => [ :show ]
    respond_to :json

    # PUT /api/v1/question/update
    def update
      if params[:id]
        begin
          case params[:entity_type]
          when "game_question"
            entity = GameQuestion.find(params[:id])
          when "game_option"
            entity = GameOption.find(params[:id])
          when "hint"
            entity = Hint.find(params[:id])
          default
            entity = HintContent.find(params[:id])
          end
          entity.update_content(params) if !entity.nil?
          render json: entity.details
        rescue ActiveRecord::RecordNotFound
          error_response("Couldn't find #{params[:entity_type]} with 'id'=#{params[:id]}", :not_found) 
        rescue ActiveRecord::RecordInvalid => invalid
          error_response(entity.errors.full_messages[0], :unprocessable_entity) 
        end
      else
        error_response("No entity_id is present") 
      end
    end
    
    # GET /api/v1/question/:id/details
    def details
      if params[:id]
        begin
          game_question = GameQuestion.find(params[:id])
          render json: game_question.details
        rescue ActiveRecord::RecordNotFound
          error_response("Couldn't find game_question with 'id'=#{params[:id]}", :not_found) 
        rescue ActiveRecord::RecordInvalid => invalid
          error_response(game_question.errors.full_messages[0], :unprocessable_entity) 
        end
      else
        error_response("No question id is present") 
      end
    end

    # GET /api/v1/question/option/:id/details
    def option_details
      if params[:id]
        begin
          game_option = GameOption.find(params[:id])
          render json: game_option.details
        rescue ActiveRecord::RecordNotFound
          error_response("Couldn't find game_option with 'id'=#{params[:id]}", :not_found) 
        rescue ActiveRecord::RecordInvalid => invalid
          error_response(game_option.errors.full_messages[0], :unprocessable_entity) 
        end
      else
        error_response("No option id is present") 
      end
    end

    # GET /api/v1/question/:game_id/structure
    def structure
      begin
        game_holder = GameHolder.find(params[:game_id])
        render json: Question.structure(game_holder.game)
      rescue ActiveRecord::RecordNotFound
        error_response("Couldn't find GameHolder with 'id'=#{params[:game_id]}", :not_found) 
      end
    end

    # POST /api/v1/question/:game_id/create
    def create
      begin
        game_holder = GameHolder.find(params[:game_id])
        game_question = GameQuestion.create_complete_question(game_holder,params)
        render json: game_question.details
      rescue ActiveRecord::RecordInvalid => invalid
        error_response("Couldn't create question because #{invalid.record.errors}", :not_found) 
      rescue ActiveRecord::RecordNotFound
        error_response("Couldn't find GameHolder with 'id'=#{params[:game_id]}", :not_found)
      rescue Exception => error
        error_response("Couldn't create question because of error: #{error}", :not_found) 
      end
    end

    # POST /api/v1/question/:game_question_id/option
    def create_option
      begin
        game_question = GameQuestion.find(params[:game_question_id])
        game_option = GameOption.create_content(game_question, params)
        render json: game_option.details
      rescue ActiveRecord::RecordInvalid => invalid
        error_response("Couldn't create question because #{invalid.record.errors}", :not_found) 
      rescue ActiveRecord::RecordNotFound
        error_response("Couldn't find GameQuestion with 'id'=#{params[:game_question_id]}", :not_found)
      rescue Exception => error
        error_response("Couldn't create question because of error: #{error}", :not_found) 
      end
    end
  end
end