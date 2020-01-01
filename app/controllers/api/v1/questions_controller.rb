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
          ActiveRecord::Base.transaction do
            entity.update_content(params) if !entity.nil?
          end
          render json: entity.details
        rescue ActiveRecord::RecordNotFound
          error_response("Couldn't find #{params[:entity_type]} with 'id'=#{params[:id]}", :ok) 
        rescue ActiveRecord::RecordInvalid => invalid
          error_response(entity.errors.full_messages[0], :ok) 
        rescue Exception => error
          error_response("Error: #{error}", :ok) 
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
          error_response("Couldn't find game_question with 'id'=#{params[:id]}", :ok) 
        rescue ActiveRecord::RecordInvalid => invalid
          error_response(game_question.errors.full_messages[0], :ok) 
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
          error_response("Couldn't find game_option with 'id'=#{params[:id]}", :ok) 
        rescue ActiveRecord::RecordInvalid => invalid
          error_response(game_option.errors.full_messages[0], :ok) 
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
        error_response("Couldn't find GameHolder with 'id'=#{params[:game_id]}", :ok) 
      end
    end

    # POST /api/v1/question/:game_id/create
    def create
      begin
        game_holder = GameHolder.find(params[:game_id])
        game_question = GameQuestion.last
        ActiveRecord::Base.transaction do
          game_question = GameQuestion.create_complete_question(game_holder,params)
        end
        render json: game_question.details
      rescue ActiveRecord::RecordInvalid => invalid
        error_response("Couldn't create question because #{invalid.record.errors}", :ok) 
      rescue ActiveRecord::RecordNotFound
        error_response("Couldn't find GameHolder with 'id'=#{params[:game_id]}", :ok)
      rescue Exception => error
        error_response("Error: #{error}", :ok) 
      end
    end

    # POST /api/v1/question/:game_question_id/option
    def create_option
      begin
        game_question = GameQuestion.find(params[:game_question_id])
        game_option = game_question.game_options.last
        ActiveRecord::Base.transaction do
          game_option = GameOption.create_content(game_question, params)
        end
        render json: game_option.details
      rescue ActiveRecord::RecordInvalid => invalid
        error_response("Couldn't create question because #{invalid.record.errors}", :ok) 
      rescue ActiveRecord::RecordNotFound
        error_response("Couldn't find GameQuestion with 'id'=#{params[:game_question_id]}", :ok)
      rescue Exception => error
        error_response("Error: #{error}", :ok) 
      end
    end

    # DELETE /api/v1/question/:game_question_id/:status
    def delete_question
      begin
        game_question = GameQuestion.find(params[:game_question_id])
        game_question.update_attributes!(delete_status: params[:status].to_i)
        render json: { status: game_question.delete_status,
          message: "GameQuestion of id =#{params[:game_question_id]} : #{game_question.delete_status}"}
      rescue ActiveRecord::RecordInvalid => invalid
        error_response("Couldn't create question because #{invalid.record.errors}", :ok) 
      rescue ActiveRecord::RecordNotFound
        error_response("Couldn't find GameQuestion with 'id'=#{params[:game_question_id]}", :ok)
      rescue Exception => error
        error_response("Error: #{error}", :ok) 
      end
    end

    # DELETE /api/v1/option/:game_option_id/:status
    def delete_option
      begin
        game_option = GameOption.find(params[:game_option_id])
        game_option.update_attributes!(delete_status: params[:status].to_i)
        render json: { status: game_option.delete_status,
          message: "Deleted GameOption of id =#{params[:game_option_id]} : #{game_option.delete_status}"}
      rescue ActiveRecord::RecordInvalid => invalid
        error_response("Couldn't create question because #{invalid.record.errors}", :ok) 
      rescue ActiveRecord::RecordNotFound
        error_response("Couldn't find GameOption with 'id'=#{params[:game_option_id]}", :ok)
      rescue Exception => error
        error_response("Error: #{error}", :ok) 
      end
    end

    # POST /api/v1/question/:game_question_id/child
    def create_child_question
      begin
        parent_game_question = GameQuestion.find(params[:game_question_id])
        child_game_question = parent_game_question.sub_questions.first
        ActiveRecord::Base.transaction do
          child_game_question = parent_game_question.create_child_question(params)
        end
        render json: child_game_question.details
      rescue ActiveRecord::RecordInvalid => invalid
        error_response("Couldn't create question because #{invalid.record.errors}", :ok) 
      rescue ActiveRecord::RecordNotFound
        error_response("Couldn't find GameQuestion with 'id'=#{params[:game_question_id]}", :ok)
      rescue Exception => error
        error_response("Error: #{error}", :ok) 
      end
    end
  end
end
