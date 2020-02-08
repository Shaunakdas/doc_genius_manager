class GameLevel < ApplicationRecord
  belongs_to :game_holder
  belongs_to :intro_discussion, class_name: "CharacterDiscussion", optional: true
  belongs_to :success_discussion, class_name: "CharacterDiscussion", optional: true
  belongs_to :fail_discussion, class_name: "CharacterDiscussion", optional: true
  # :id, :title, :sub_title, :name, :slug, :sequence, :game, :image_url, :enabled
  has_many :game_level_victory_cards
  has_many :victory_cards, through: :game_level_victory_cards
  has_one :score_structure
  has_many :game_sessions
  has_many :game_questions

  enum practice_mode: [ :introduction, :learning, :practice]
  # enum nature_effect: [ :
  def title
    game_holder.title
  end

  def sub_title
    game_holder.sub_title
  end

  def sequence
    game_holder.sequence
  end

  def enabled
    game_holder.enabled
  end

  def game
    game_holder.game
  end

  def self.create_default_levels
    Standard.first.chapters.all.each do |c|
      c.practice_game_holders.all.each do |g_h|
        if g_h.game_levels.count == 0
          g_h.game_levels.create!(name: "Game Level #{g_h.name}", slug: "game-level-#{g_h.slug}")
        end
      end 
    end
  end

  def image_url
    game_holder.image_url
  end

  def intro_character_discussion
    return intro_discussion if !intro_discussion.nil?
    return CharacterDiscussion.get_default
  end

  def success_character_discussion
    return success_discussion if !success_discussion.nil?
    return CharacterDiscussion.get_default
  end

  def fail_character_discussion
    return fail_discussion if !fail_discussion.nil?
    return CharacterDiscussion.get_default
  end

  def success_victory_cards
    return victory_cards if victory_cards.count != 0 
    return [VictoryCard.get_default]
  end
end
