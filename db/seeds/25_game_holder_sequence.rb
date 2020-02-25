require 'rubyXL'
book = RubyXL::Parser.parse('question_source/screenplays/scripts/Base_WorkingRule.xlsx')

def get_bool correct
    return (correct.nil? ? nil : ((correct.value =="TRUE")||(correct.value ==1)))
end

def get_val cell
    return (cell.nil? ? nil : cell.value)
end

def delete_game_holder_sequences
    GameHolder.where.not(sequence: nil).each do |g|
        g.update_attributes!(sequence: nil)
    end
end
# Uploading basic acad entities
def upload_game_holder_sequences(book, count)
    master_sheet = book[count]
    master_sheet.each do |row|
        if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.to_s.include? 'C06' )
            game_holder_slug = get_val(row.cells[17])

            game_holder = GameHolder.find_by(:slug => game_holder_slug)
            sequence = get_val(row.cells[15])
            if game_holder && sequence
                puts "Mapping GameHolder #{game_holder.to_json} to Sequence #{sequence}"
                game_holder.update_attributes!(sequence: sequence)
            else
                puts "Couldn't Map GameHolder #{game_holder.to_json} to Sequence #{sequence}"
            end
        end
        break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
    end
end

game_start = 3
delete_game_holder_sequences
upload_game_holder_sequences(book, game_start)