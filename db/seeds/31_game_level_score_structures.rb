require 'rubyXL'
book = RubyXL::Parser.parse('question_source/screenplays/scripts/Base_WorkingRule.xlsx')

def get_bool correct
    return (correct.nil? ? nil : ((correct.value =="TRUE")||(correct.value ==1)))
end

def get_val cell
    return (cell.nil? ? nil : cell.value)
end
# Uploading basic acad entities
def upload_game_levels(book, count)
    master_sheet = book[count]
    master_sheet.each do |row|
        if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.to_s.include? 'for' )
            game_holder_slug = row.cells[1].value

            game_holder = GameHolder.find_by(:slug => game_holder_slug)

            if game_holder
                game_level_slug = get_val(row.cells[4])
                game_level_params = {
                    game_holder: game_holder,
                    sequence: get_val(row.cells[2]),
                    name: get_val(row.cells[3]),
                    slug: game_level_slug,
                    practice_mode: get_val(row.cells[5]),
                    nature_effect: get_val(row.cells[6])
                }

                #Create or find stream
                if not game_level = GameLevel.find_by(:slug => game_level_slug)
                    puts "Adding GameLevel #{game_level_params.to_json} "
                    game_level = GameLevel.create!(game_level_params)
                else
                    game_level.update_attributes!(game_level_params)
                end
            end
        end
        break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
    end
end

def delete_game_level_without_mode
    delete_character_discussion_models
    delete_victory_cards
    GameLevel.all.each do |g|
        ScoreStructure.delete(g.score_structure)
        GameLevel.delete(g) 
    end
end


# Uploading basic acad entities
def upload_game_score_structures(book, count)
    master_sheet = book[count]
    master_sheet.each do |row|
        if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.to_s.include? 'for' )
            game_level_slug = row.cells[4].value

            game_level = GameLevel.find_by(:slug => game_level_slug)

            if game_level
                game_level_name = row.cells[3].value

                score_index = 7

                score_structure_params = {
                    game_level: game_level,
                    game_holder: game_level.game_holder,
                    limiter_time_question: get_val(row.cells[score_index]),
                    limiter_time_game: get_val(row.cells[score_index+1]),
                    limiter_option: get_val(row.cells[score_index+2]),
                    limiter_question: get_val(row.cells[score_index+3]),
                    limiter_lives: get_val(row.cells[score_index+4]),
                    marks_normal_attempt: get_val(row.cells[score_index+5]),
                    marks_normal_time: get_val(row.cells[score_index+6]),
                    marks_speedy_time_limit: get_val(row.cells[score_index+7]),
                    marks_speedy_max: get_val(row.cells[score_index+8]),
                    marks_complete_set: get_val(row.cells[score_index+9]),
                    marks_remaining_lives: get_val(row.cells[score_index+10]),
                    marks_actual_answer: get_val(row.cells[score_index+11]),
                    marks_consistency_bonus: get_val(row.cells[score_index+12]),
                    marks_remaining_time: get_val(row.cells[score_index+13]),
                    star_threshold_2: get_val(row.cells[score_index+14]),
                    star_threshold_3: get_val(row.cells[score_index+15]),
                    display_report_accuracy: get_bool(row.cells[score_index+16]),
                    display_report_content: get_bool(row.cells[score_index+17]),
                    display_remaining_lives: get_bool(row.cells[score_index+18]),
                    display_speedy_answer: get_bool(row.cells[score_index+19]),
                    display_perfect_set: get_bool(row.cells[score_index+20]),
                    display_longest_streak: get_bool(row.cells[score_index+21]),
                    display_accurate_answer: get_bool(row.cells[score_index+22]),
                    display_errors: get_bool(row.cells[score_index+23]),
                    display_remaining_time: get_bool(row.cells[score_index+24])
                }

                #Create or find stream
                if not score_structure = game_level.score_structure
                    puts "Adding Score Structure of #{game_level.name}"
                    score_structure = ScoreStructure.create!(score_structure_params)
                else
                    score_structure.update_attributes!(score_structure_params)
                end
            end
        end
        break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
    end
end

def delete_character_discussion_models
    GameLevel.all.each do |level|
        level.update_attributes!(intro_discussion: nil, success_discussion: nil, fail_discussion: nil)
    end
    CharacterDialog.delete_all
    CharacterDiscussion.delete_all
    Character.delete_all
    Weapon.delete_all
end

def delete_victory_cards
    GameLevelVictoryCard.delete_all
    VictoryCard.delete_all
end


game_start = 22
delete_game_level_without_mode
upload_game_levels(book, game_start)
upload_game_score_structures(book, game_start)