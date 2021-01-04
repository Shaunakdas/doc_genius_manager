require 'rubyXL'
book = RubyXL::Parser.parse('question_source/screenplays/scripts/ExternalQuiz.xlsx')

def get_bool correct
    return (correct.nil? ? nil : ((correct.value =="TRUE")||(correct.value ==1)))
end

def get_val cell
    return (cell.nil? ? nil : cell.value)
end

# Uploading basic acad entities
def upload_external_questions(book, count)
    master_sheet = book[count]
    master_sheet.each_with_index do |row,i|
        next if i < 640
        if row.cells[0]  && row.cells[0].value
            quiz_index = 0
            quiz_url = get_val(row.cells[quiz_index+7])
            quiz_params = {
                title: get_val(row.cells[quiz_index]),
                quiz_type: get_val(row.cells[quiz_index+1]),
                grade: get_val(row.cells[quiz_index+2]),
                accuracy: check_accuracy(get_val(row.cells[quiz_index+3])),
                plays: get_val(row.cells[quiz_index+4])[0..-7].to_i,
                subject: get_val(row.cells[quiz_index+5]),
                image_url: get_val(row.cells[quiz_index+6]),
                source_url: quiz_url
            }
            if not external_quiz_source = ExternalQuizSource.find_by(:source_url => quiz_url)
                puts "Adding ExternalQuizSource #{quiz_params.to_json} "
                external_quiz_source = ExternalQuizSource.create!(quiz_params)
            else
                external_quiz_source.update_attributes!(quiz_params)
            end
            question_index = 8
            while(!get_val(row.cells[question_index]).nil?)  do
                options = get_val(row.cells[question_index+1])
                question_params = {
                    question: get_val(row.cells[question_index]),
                    options: get_options(options,get_val(row.cells[question_index+2])),
                    correct_option: check_option_index(options,get_val(row.cells[question_index+2])),
                    time: get_val(row.cells[question_index+3])[0..-9].to_i,
                    image_url: get_val(row.cells[question_index+4]),
                    audio_url: get_val(row.cells[question_index+5]),
                    external_quiz_source: external_quiz_source
                }
                puts "Adding ExternalQuestion #{question_params.to_json} "
                ExternalQuestion.create!(question_params)
                question_index = question_index+6
            end
        end
        break if i == 1231
    end
end

def check_accuracy accuracy
    return 0 if accuracy.to_s == ""
    accuracy[0..-18].to_i
end

def get_options(options,answer)
    return answer if options.to_s == ""
    return options
end

def check_option_index(options,answer)
    answer = answer.titleize if answer == "TRUE"
    return -1 if options.to_s == ""
    return options.split("\n---\n").find_index(answer)
end

game_start = 0
upload_external_questions(book, game_start)