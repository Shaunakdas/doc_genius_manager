require 'rubyXL'
book = RubyXL::Parser.parse('question_source/screenplays/scripts/Base_WorkingRule.xlsx')

def get_bool correct
    return (correct.nil? ? nil : ((correct.value =="TRUE")||(correct.value ==1)))
end

def get_val cell
    return (cell.nil? ? nil : cell.value)
end

def delete_game_level_questions
    GameQuestion.where.not(game_level: nil).each do |q|
        q.update_attributes!(game_level: nil)
    end
end
# Uploading basic acad entities
def upload_game_level_questions(book, count)
    master_sheet = book[count]
    master_sheet.each do |row|
        if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.to_s.include? 'for' )
            game_level_slug = row.cells[1].value

            game_level = GameLevel.find_by(:slug => game_level_slug)

            if game_level
                question_slug = get_val(row.cells[3])
                question = Question.find_by(code: question_slug)

                game_question = GameQuestion.where(question: question).first
                if game_level && game_question
                    puts "Mapping GameLevel #{game_level.to_json} to GameQuestion #{game_question.to_json}"
                    game_question.update_attributes!(game_level: game_level)
                else
                    puts "Couldn't Map GameLevel #{game_level.to_json} to GameQuestion #{game_question.to_json} (#{question_slug})"
                end
                    
            end
        end
        break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
    end
end

game_start = 25
# delete_game_level_questions
# upload_game_level_questions(book, game_start)