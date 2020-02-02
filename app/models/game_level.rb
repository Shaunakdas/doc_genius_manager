class GameLevel < ApplicationRecord
  belongs_to :game_holder
  belongs_to :intro_discussion, class_name: "CharacterDiscussion", optional: true
  belongs_to :success_discussion, class_name: "CharacterDiscussion", optional: true
  belongs_to :fail_discussion, class_name: "CharacterDiscussion", optional: true
  # :id, :title, :sub_title, :name, :slug, :sequence, :game, :image_url, :enabled

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
end
