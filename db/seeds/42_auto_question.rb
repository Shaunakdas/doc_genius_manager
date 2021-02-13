require 'rubyXL'
book = RubyXL::Parser.parse('question_source/screenplays/scripts/QuizizzSampleSpreadsheet.xlsx')

def get_val cell
  return (cell.nil? ? nil : cell.value)
end

def upload_question(book, count)
  master_sheet = book[count]
  null_row_counter = 0
  master_sheet.each do |row|
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

        correct_op_index_array = correct_option_index.nil? [] : correct_option_index.split(',')

        if question

          question = Question.create!(display: display, image_url: image_url)
          puts "Adding question display: #{display} "
          game_question = GameQuestion.create!(question: question)

          option_array = [option_1,option_2,option_3,option_4,option_5].compact
          option_array.each_with_index do |option,i|
            option = Option.create( display: display, correct: (correct_op_index_array.index(i+1)))
            puts "Adding option_#{(i+1)} display: #{display}"
            game_option = GameOption.create!(option: option, game_question: game_question)
          end
        end
      end
      
    else
      null_row_counter = null_row_counter + 1
    end
    break if null_row_counter > 10
  end
end