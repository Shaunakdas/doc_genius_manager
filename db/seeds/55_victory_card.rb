require 'rubyXL'
book = RubyXL::Parser.parse('question_source/screenplays/scripts/Base_WorkingRule.xlsx')

def get_bool correct
    return (correct.nil? ? nil : ((correct.value =="TRUE")||(correct.value ==1)))
end

def get_val cell
    return (cell.nil? ? nil : cell.value)
end

def delete_victory_cards
    GameLevelVictoryCard.delete_all
    VictoryCard.delete_all
end

# Uploading basic acad entities
def upload_character_victory_cards(book, count)
    master_sheet = book[count]
    master_sheet.each do |row|
        if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.to_s.include?('Game') || row.cells[0].value.to_s.include?('Chapter') )
            acad_entity_slug = row.cells[2].value
            acad_entity_type = get_val(row.cells[0])
            if acad_entity_type == "GameLevel"
                acad_entity = GameLevel.where(slug: acad_entity_slug).first
            elsif acad_entity_type == "GameHolder"
                acad_entity = GameHolder.where(slug: acad_entity_slug).first
            elsif acad_entity_type == "Chapter"
                acad_entity = Chapter.where(slug: acad_entity_slug).first
            end

            if acad_entity
                victory_card_slug = get_val(row.cells[3])
                victory_card_params = {
                    acad_entity: acad_entity,
                    sequence: get_val(row.cells[3]),
                    name: get_val(row.cells[4]),
                    slug: get_val(row.cells[5]),
                    title: get_val(row.cells[6]),
                    description: get_val(row.cells[7]),
                    max_count: 1
                }

                #Create or find CharacterDiscussion
                if not victory_card = VictoryCard.find_by(:slug => victory_card_slug)
                    puts "Adding VictoryCard #{victory_card_params.to_json} "
                    victory_card = VictoryCard.create!(victory_card_params)
                else
                    victory_card.update_attributes!(victory_card_params)
                end
            end
        end
        break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
    end
end

def create_game_level_vistory_card
    GameLevel.order('id ASC').all.each do |level|
        puts "GameLevel : #{level.to_json}"
        next if level.linked_victory_card.nil?
        GameLevelVictoryCard.create!(game_level: level,
            victory_card: level.linked_victory_card,
            current_count: 1)
        puts "Creating GameLevelVictoryCard for GameLevel : #{level.to_json} for card: #{level.linked_victory_card.to_json}"
    end
    GameHolder.order('id ASC').where.not(sequence: nil).all.each do |game_holder|
        puts "GameHolder : #{game_holder.to_json}"
        next if game_holder.linked_victory_card.nil?
        max_count = 0
        game_holder.game_levels.each do |game_level|
            max_count = [max_count,game_level.sequence.to_i].max
            card_ref = GameLevelVictoryCard.create!(game_level: game_level,
                victory_card: game_holder.linked_victory_card,
                current_count: game_level.sequence)
            puts "Creating GameLevelVictoryCard attributes :#{card_ref.to_json}"
        end
        game_holder.linked_victory_card.update_attributes!(max_count: max_count)
        puts "Creating GameLevelVictoryCard for GameHolder : #{game_holder.to_json} for card: #{game_holder.linked_victory_card.to_json}"
    end
    Chapter.order('id ASC').all.each do |chapter|
        puts "Chapter : #{chapter.to_json}"
        next if chapter.linked_victory_card.nil?
        max_count = 0
        chapter.practice_game_holders.where.not(sequence: nil).each do |game_holder|
            max_count = [max_count,game_holder.sequence.to_i].max
            game_level = game_holder.game_levels.order("sequence DESC").last
            if game_level
                card_ref = GameLevelVictoryCard.create!(game_level: game_level,
                    victory_card: chapter.linked_victory_card,
                    current_count: game_holder.sequence)
                puts "Creating GameLevelVictoryCard attributes :#{card_ref.to_json}"
            end
        end
        chapter.linked_victory_card.update_attributes!(max_count: max_count)
        puts "Creating GameLevelVictoryCard for Chapter : #{chapter.to_json} for card: #{chapter.linked_victory_card.to_json}"
    end
end

game_start = 24
# delete_victory_cards
# upload_character_victory_cards(book, game_start)
# create_game_level_vistory_card