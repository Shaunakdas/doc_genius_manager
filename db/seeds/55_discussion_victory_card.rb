require 'rubyXL'
book = RubyXL::Parser.parse('question_source/screenplays/scripts/Base_WorkingRule.xlsx')

def get_bool correct
    return (correct.nil? ? nil : ((correct.value =="TRUE")||(correct.value ==1)))
end

def get_val cell
    return (cell.nil? ? nil : cell.value)
end

def create_slug name
    name.downcase.gsub!(/\s/,'-') + [*('a'..'z')].sample(6).join
end

def delete_victory_cards
    GameLevelVictoryCard.delete_all
    VictoryCard.delete_all
end

# Uploading basic acad entities
def upload_character_victory_cards(book, count, update_armory)
    master_sheet = book[count]
    master_sheet.each do |row|
        if row.cells[0]  && row.cells[0].value
            acad_entity_slug = get_val(row.cells[3])
            acad_entity_type = get_val(row.cells[2])
            if acad_entity_type == "GameLevel"
                acad_entity = GameLevel.where(slug: acad_entity_slug).first
            elsif acad_entity_type == "GameHolder"
                acad_entity = GameHolder.where(slug: acad_entity_slug).first
            elsif acad_entity_type == "Chapter"
                acad_entity = Chapter.where(slug: acad_entity_slug).first
            end

            if acad_entity
                if acad_entity_type == "GameHolder" && update_armory
                    armory_index = 13
                    update_level_armory(row, armory_index, acad_entity)
                else
                    victory_card_slug = get_val(row.cells[10])
                    victory_card_params = {
                        acad_entity: acad_entity,
                        sequence: get_val(row.cells[6]),
                        name: get_val(row.cells[9]),
                        slug: get_val(row.cells[10]),
                        title: get_val(row.cells[11]),
                        description: get_val(row.cells[12]),
                        max_count: 1
                    }

                    #Create or find CharacterDiscussion
                    if not victory_card = VictoryCard.find_by(:slug => victory_card_slug)
                        puts "Adding VictoryCard #{victory_card_params.to_json} "
                        victory_card = VictoryCard.create!(victory_card_params)
                    else
                        victory_card.update_attributes!(victory_card_params)
                    end

                    weapon_index = 25
                    update_level_weapon(row, weapon_index, acad_entity) if acad_entity_type == "GameLevel" && !update_armory
                end
                
                 
            end
        end
        break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
    end
end

def update_level_weapon row, weapon_index, game_level
    puts "Updating weapon item of future game levels"
    weapon = get_weapon(row, weapon_index)
    weapon_color = get_val(row.cells[weapon_index+2])
    game_level.success_discussion.
        update_dialog_weapon("arjun-arj", weapon, weapon_color, true)
    return nil if game_level.next_game_level.nil?
    return nil if game_level.next_game_level.intro_discussion.nil?
    game_level.next_game_level.intro_discussion.
        update_dialog_weapon("arjun-arj", weapon, weapon_color, true)
    return nil if game_level.next_game_level.fail_discussion.nil?
    game_level.next_game_level.fail_discussion.
        update_dialog_weapon("arjun-arj", weapon, weapon_color, true)
end

def update_level_armory row, armory_index, game_holder
    puts "Updating armory item of future game levels"
    game_level = game_holder.game_levels.where(enabled: true).last
    return nil if game_level.nil?
    boots_index = armory_index
    pants_index = armory_index + 2
    gloves_index = armory_index + 4
    armor_index = armory_index + 6
    cape_index = armory_index + 8
    helmet_index = armory_index + 10

    boots_name = get_val(row.cells[boots_index])
    boots_colour = get_val(row.cells[boots_index + 1])
    game_level.success_discussion.character_dialogs.where(character: get_arjun_character).each do |dialog|
        dialog.update_attributes!(boots_name: boots_name, boots_colour: boots_colour)
        puts "Updated boots in #{dialog.to_json}"
    end
    
    game_level.next_game_levels.each do |level|
        level.all_character_discussions.each do |discussion|
            discussion.character_dialogs.where(character: get_arjun_character).each do |dialog|
                dialog.update_attributes!(boots_name: boots_name, boots_colour: boots_colour)
                puts "Updated boots in #{dialog.to_json}"
            end
        end
    end

    pants_name = get_val(row.cells[pants_index])
    pants_colour = get_val(row.cells[pants_index + 1])
    game_level.success_discussion.character_dialogs.where(character: get_arjun_character).each do |dialog|
        dialog.update_attributes!(pants_name: pants_name, pants_colour: pants_colour)
        puts "Updated pants in #{dialog.to_json}"
    end
    game_level.next_game_levels.each do |level|
        level.all_character_discussions.each do |discussion|
            discussion.character_dialogs.where(character: get_arjun_character).each do |dialog|
                dialog.update_attributes!(pants_name: pants_name, pants_colour: pants_colour)
                puts "Updated pants in #{dialog.to_json}"
            end
        end
    end

    gloves_name = get_val(row.cells[gloves_index])
    gloves_colour = get_val(row.cells[gloves_index + 1])
    game_level.success_discussion.character_dialogs.where(character: get_arjun_character).each do |dialog|
        dialog.update_attributes!(gloves_name: gloves_name, gloves_colour: gloves_colour)
        puts "Updated gloves in #{dialog.to_json}"
    end
    game_level.next_game_levels.each do |level|
        level.all_character_discussions.each do |discussion|
            discussion.character_dialogs.where(character: get_arjun_character).each do |dialog|
                dialog.update_attributes!(gloves_name: gloves_name, gloves_colour: gloves_colour)
                puts "Updated gloves in #{dialog.to_json}"
            end
        end
    end

    armor_name = get_val(row.cells[armor_index])
    armor_colour = get_val(row.cells[armor_index + 1])
    game_level.success_discussion.character_dialogs.where(character: get_arjun_character).each do |dialog|
        dialog.update_attributes!(armor_name: armor_name, armor_colour: armor_colour)
        puts "Updated Armor in #{dialog.to_json}"
    end
    
    game_level.next_game_levels.each do |level|
        level.all_character_discussions.each do |discussion|
            discussion.character_dialogs.where(character: get_arjun_character).each do |dialog|
                dialog.update_attributes!(armor_name: armor_name, armor_colour: armor_colour)
            puts "Updated Armor in #{dialog.to_json}"
            end
        end
    end

    cape_name = get_val(row.cells[cape_index])
    cape_colour = get_val(row.cells[cape_index + 1])
    game_level.success_discussion.character_dialogs.where(character: get_arjun_character).each do |dialog|
        dialog.update_attributes!(cape_name: cape_name, cape_colour: cape_colour)
        puts "Updated cape in #{dialog.to_json}"
    end
    game_level.next_game_levels.each do |level|
        level.all_character_discussions.each do |discussion|
            discussion.character_dialogs.where(character: get_arjun_character).each do |dialog|
                dialog.update_attributes!(cape_name: cape_name, cape_colour: cape_colour)
                puts "Updated cape in #{dialog.to_json}"
            end
        end
    end

    helmet_name = get_val(row.cells[helmet_index])
    helmet_colour = get_val(row.cells[helmet_index + 1])
    game_level.success_discussion.character_dialogs.where(character: get_arjun_character).each do |dialog|
        dialog.update_attributes!(helmet_name: helmet_name, helmet_colour: helmet_colour)
        puts "Updated helmet in #{dialog.to_json}"
    end
    game_level.next_game_levels.each do |level|
        level.all_character_discussions.each do |discussion|
            discussion.character_dialogs.where(character: get_arjun_character).each do |dialog|
                dialog.update_attributes!(helmet_name: helmet_name, helmet_colour: helmet_colour)
                puts "Updated helmet in #{dialog.to_json}"
            end
        end
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

def delete_character_discussion_models
    GameLevel.all.each do |level|
        level.update_attributes!(intro_discussion: nil, success_discussion: nil, fail_discussion: nil)
    end
    CharacterDialog.delete_all
    CharacterDiscussion.delete_all
    Character.delete_all
    Weapon.delete_all
end

# Uploading basic acad entities
def upload_character_discussions(book, count)
    master_sheet = book[count]
    master_sheet.each do |row|
        if row.cells[0]  && row.cells[0].value
            game_level_slug = row.cells[3].value

            game_level = GameLevel.find_by(:slug => game_level_slug)

            if game_level
                weapon_index = 7
                introduction_index = 13
                success_index = 19
                failure_index = 25

                get_complete_discussion(row, introduction_index, weapon_index, "Introduction", game_level)
                get_complete_discussion(row, introduction_index, weapon_index, "Success", game_level)
                get_complete_discussion(row, introduction_index, weapon_index, "Failure", game_level)
            end
        end
        break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
    end
end

def get_complete_discussion row, start_index, weapon_index, stage, game_level
    return if get_val(row.cells[start_index]).nil?
    puts "Creating Complete Character Discussion of #{stage} for #{game_level.name}"
    discussion = get_discussion(stage, game_level)

    game_level.update_attributes!(intro_discussion: discussion) if discussion.stage == "introduction"
    game_level.update_attributes!(success_discussion: discussion) if discussion.stage == "success"
    game_level.update_attributes!(fail_discussion: discussion) if discussion.stage == "failure"
    
    final_index = 0
    finished = false
    (0..5).each do |index|
        finished = true if get_val(row.cells[start_index + index]).nil?
        drona_flag = (index%2 == 0)
        character = drona_flag ? get_drona_character : get_arjun_character
        if drona_flag
            right_weapon = get_weapon(row, weapon_index)
            right_weapon_colour = get_val(row.cells[weapon_index+2])
        else
            left_weapon = get_weapon(row, weapon_index+3)
            left_weapon_colour = get_val(row.cells[weapon_index+5])
        end
        comment = get_val(row.cells[start_index + index])
        if discussion && character
            if finished 
                if (game_level.practice_mode != "introduction") && (stage != "Introduction")
                    final_index = setup_discussion(discussion, character, stage, final_index, drona_flag, nil,
                        left_weapon, left_weapon_colour, right_weapon, right_weapon_colour, "walk_out")
                end
                break
            end
            if (game_level.practice_mode == "introduction") && (stage == "Introduction") && drona_flag && (index == 0)
                final_index = setup_discussion(discussion, character, stage, final_index, drona_flag, nil,
                    left_weapon, left_weapon_colour, right_weapon, right_weapon_colour, "walk_in")
            elsif (game_level.practice_mode == "introduction") && (stage == "Introduction") && !drona_flag && (index == 1)
                final_index = setup_discussion(discussion, character, stage, final_index, drona_flag, nil,
                    left_weapon, left_weapon_colour, right_weapon, right_weapon_colour, "walk_in")
            end
            animation = "talk"
            animation = "strike" if (game_level.practice_mode != "introduction") && (stage == "Success")
            final_index = setup_discussion(discussion, character, stage, final_index, drona_flag, comment,
                left_weapon, left_weapon_colour, right_weapon, right_weapon_colour, animation)
        end
    end
end

def setup_discussion discussion, character, stage, index, drona_flag, comment, left_weapon, left_weapon_colour, right_weapon, right_weapon_colour, animation
    dialog_slug = create_slug("#{stage} Dialog")
    dialog_params = {
        character_discussion: discussion,
        slug: dialog_slug,
        sequence: index + 1,
        character: character,
        position: (drona_flag ? "left": "right"),
        animation: animation,
        comment: comment,
        repeat_mode: "never",
        left_weapon: left_weapon,
        left_weapon_colour: left_weapon_colour,
        right_weapon: right_weapon,
        right_weapon_colour: right_weapon_colour,
    }
    character_dialog = get_dialog(dialog_slug, dialog_params)
    return index + 1
end
def get_discussion stage, game_level
    discussion_name = stage.titleize + " of " + game_level.name
    discussion_slug = create_slug(discussion_name)
    discussion_params = {
        name: discussion_name,
        slug: discussion_slug,
        stage: stage.downcase
    }

    #Create or find CharacterDiscussion
    if not discussion = CharacterDiscussion.find_by(:slug => discussion_slug)
        puts "Adding CharacterDiscussion #{discussion_params.to_json} "
        discussion = CharacterDiscussion.create!(discussion_params)
    else
        discussion.update_attributes!(discussion_params)
    end
end

def get_weapon row, cell_index
    weapon_slug = get_val(row.cells[cell_index+1])
    return nil if weapon_slug.nil?
    weapon_params = {
        name: get_val(row.cells[cell_index]),
        slug: weapon_slug
    }
    #Create or find Charactercharacter
    if not weapon = Weapon.find_by(:slug => weapon_slug)
        puts "Adding weapon #{weapon_params.to_json} "
        weapon = Weapon.create!(weapon_params)
    else
        weapon.update_attributes!(weapon_params)
    end
    return weapon
end

def get_drona_character
    character_slug = "drona-dro"
    character_params = {
        name: "Drona",
        slug: character_slug
    }
    return get_character(character_slug, character_params)
end

def get_arjun_character
    character_slug = "arjun-arj"
    character_params = {
        name: "Arjun",
        slug: character_slug
    }
    return get_character(character_slug, character_params)
end

def get_character character_slug, character_params
    #Create or find Character
    if not character = Character.find_by(:slug => character_slug)
        puts "Adding Character #{character_params.to_json} "
        character = Character.create!(character_params)
    else
        character.update_attributes!(character_params)
    end
    return character
end

def get_dialog dialog_slug, dialog_params
    #Create or find Characterdialog
    if not dialog = CharacterDialog.find_by(:slug => dialog_slug)
        puts "Adding Character Dialog #{dialog_params.to_json} "
        dialog = CharacterDialog.create!(dialog_params)
    else
        dialog.update_attributes!(dialog_params)
    end
end

game_start = 25
# delete_character_discussion_models
# upload_character_discussions(book, game_start)

game_start = 26
# delete_victory_cards
# upload_character_victory_cards(book, game_start, false)
# create_game_level_vistory_card

# GameHolder
# upload_character_victory_cards(book, game_start, true)