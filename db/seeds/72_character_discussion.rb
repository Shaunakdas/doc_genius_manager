require 'rubyXL'
book = RubyXL::Parser.parse('question_source/screenplays/scripts/Base_WorkingRule.xlsx')

def get_bool correct
    return (correct.nil? ? nil : ((correct.value =="TRUE")||(correct.value ==1)))
end

def get_val cell
    return (cell.nil? ? nil : cell.value)
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
        if row.cells[0]  && row.cells[0].value  && (row.cells[0].value.to_s.include? 'for' )
            game_level_slug = row.cells[1].value

            game_level = GameLevel.find_by(:slug => game_level_slug)

            if game_level
                discussion_slug = get_val(row.cells[3])
                discussion_params = {
                    name: get_val(row.cells[2]),
                    slug: get_val(row.cells[3]),
                    stage: get_val(row.cells[4])
                }

                #Create or find CharacterDiscussion
                if not discussion = CharacterDiscussion.find_by(:slug => discussion_slug)
                    puts "Adding CharacterDiscussion #{discussion_params.to_json} "
                    discussion = CharacterDiscussion.create!(discussion_params)
                else
                    discussion.update_attributes!(discussion_params)
                end

                game_level.update_attributes!(intro_discussion: discussion) if discussion.stage == "introduction"
                game_level.update_attributes!(success_discussion: discussion) if discussion.stage == "success"
                game_level.update_attributes!(fail_discussion: discussion) if discussion.stage == "failure"

                character_index = 7
                character_slug = get_val(row.cells[character_index+1])
                character_params = {
                    name: get_val(row.cells[character_index]),
                    slug: character_slug
                }
                #Create or find Charactercharacter
                if not character = Character.find_by(:slug => character_slug)
                    puts "Adding Character #{character_params.to_json} "
                    character = Character.create!(character_params)
                else
                    character.update_attributes!(character_params)
                end

                left_weapon_index = 13
                right_weapon_index = 16
                left_weapon = get_weapon(row, left_weapon_index)
                right_weapon = get_weapon(row, right_weapon_index)
                armory_index = 19

                if discussion && character
                    dialog_index = 5
                    dialog_slug = get_val(row.cells[dialog_index])
                    dialog_params = {
                        character_discussion: discussion,
                        slug: dialog_slug,
                        sequence: get_val(row.cells[dialog_index+1]),
                        character: character,
                        position: get_val(row.cells[dialog_index+4]),
                        animation: get_val(row.cells[dialog_index+5]),
                        comment: get_val(row.cells[dialog_index+6]),
                        repeat_mode: get_val(row.cells[dialog_index+7]),
                        left_weapon: left_weapon,
                        left_weapon_colour: get_val(row.cells[left_weapon_index+2]),
                        right_weapon: right_weapon,
                        right_weapon_colour: get_val(row.cells[right_weapon_index+2]),
                        helmet_name: get_val(row.cells[armory_index]),
                        helmet_colour: get_val(row.cells[armory_index+1]),
                        armor_name: get_val(row.cells[armory_index+2]),
                        armor_colour: get_val(row.cells[armory_index+3]),
                        cape_name: get_val(row.cells[armory_index+4]),
                        cape_colour: get_val(row.cells[armory_index+5]),
                        pants_name: get_val(row.cells[armory_index+6]),
                        pants_colour: get_val(row.cells[armory_index+7]),
                        gloves_name: get_val(row.cells[armory_index+8]),
                        gloves_colour: get_val(row.cells[armory_index+9]),
                        boots_name: get_val(row.cells[armory_index+10]),
                        boots_colour: get_val(row.cells[armory_index+11])
                    }
                    #Create or find Characterdialog
                    if not dialog = CharacterDialog.find_by(:slug => dialog_slug)
                        puts "Adding Character #{dialog_params.to_json} "
                        dialog = CharacterDialog.create!(dialog_params)
                    else
                        dialog.update_attributes!(dialog_params)
                    end

                end
                    
            end
        end
        break if row.cells[0] && row.cells[0].value && (row.cells[0].value == 'End')
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

game_start = 23
# delete_character_discussion_models
# upload_character_discussions(book, game_start)