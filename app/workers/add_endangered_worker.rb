class AddEndangeredWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  require 'rubyXL'

  def get_correct_op_index_array correct_option_index
    correct_op_index_array = []
    if correct_option_index
      if correct_option_index.to_s.index(',').nil?
        correct_op_index_array = [correct_option_index.to_i]
      else
        correct_op_index_array = correct_option_index.split(',')
      end
    end
    return correct_op_index_array
  end

  def create_game_question game_holder, question_display, image_url
    if question_display
      question = Question.create!(display: question_display, image_url: image_url)
      puts "Adding question display: #{question_display} "
      game_question = GameQuestion.create!(question: question, game_holder: game_holder)
      return game_question
    end
  end
  

  def get_val cell
    return (cell.nil? ? nil : cell.value)
  end

  def perform(game_holder_id, file_url)
    game_holder = GameHolder.find(game_holder_id)
    return if game_holder.nil?
    book = RubyXL::Parser.parse('question_source/screenplays/scripts/QuizizzSampleSpreadsheet.xlsx')
    master_sheet = book[0]
    null_row_counter = 0
    master_sheet.each_with_index do |row,i|
      next if i < 2
      if get_val(row.cells[0])
        null_row_counter = 0
        if row.cells[0]
          question_display = get_val(row.cells[0])
          question_type = get_val(row.cells[1])
          time_seconds = get_val(row.cells[2])
          image_url = get_val(row.cells[3])
          op_start = 4
          option_1 = get_val(row.cells[op_start])
          option_2 = get_val(row.cells[op_start+1])
          option_3 = get_val(row.cells[op_start+2])
          option_4 = get_val(row.cells[op_start+3])
          option_5 = get_val(row.cells[op_start+4])
          correct_option_index = get_val(row.cells[op_start+5])

          correct_op_index_array = get_correct_op_index_array(correct_option_index)
          
          game_question = create_game_question(game_holder, question_display, image_url)

          option_array = [option_1,option_2,option_3,option_4,option_5].compact
          option_array.each_with_index do |option_display,i|
            option = Option.create( display: option_display, correct: (correct_op_index_array.index(i+1)))
            puts "Adding option_#{i+1} display: #{option_display}"
            game_option = GameOption.create!(option: option, game_question: game_question)
          end
        end
        
      else
        null_row_counter = null_row_counter + 1
      end
      break if null_row_counter > 10
    end
  end
end
