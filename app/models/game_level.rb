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
  has_one :linked_victory_card, as: :acad_entity, class_name: "VictoryCard"

  has_many :game_questions, -> { order('difficulty_index asc') }

  enum practice_mode: [ :introduction, :learning, :practice]
  # enum nature_effect: [ :
  def title
    game_holder.title
  end

  def sub_title
    game_holder.sub_title
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
    similar_discussion = similar_discussion('introduction')
    return similar_discussion if !similar_discussion.nil?
    return CharacterDiscussion.get_default
  end

  def success_character_discussion
    return success_discussion if !success_discussion.nil?
    similar_discussion = similar_discussion('success')
    return similar_discussion if !similar_discussion.nil?
    return CharacterDiscussion.get_default
  end

  def fail_character_discussion
    return fail_discussion if !fail_discussion.nil?
    similar_discussion = similar_discussion('failure')
    return similar_discussion if !similar_discussion.nil?
    return CharacterDiscussion.get_default
  end

  def success_victory_cards
    return victory_cards if victory_cards.count != 0 
    return [VictoryCard.get_default]
  end



  def get_questions
    puts game.slug
    puts "Game Level: #{@game_level}"
    case game_holder.game.slug
    when "agility"
      return get_agility_questions
    when "conversion"
      return get_conversion_questions
    when "conversion"
      return get_conversion_questions
    when "diction"
      return get_diction_questions
    when "discounting"
      return get_discounting_questions
    when "division"
      get_division_questions
    when "estimation"
      get_estimation_questions
    when "inversion"
      get_inversion_questions
    when "percentages"
      return get_percentages_questions
    when "proportion"
      return get_proportion_questions
    when "purchasing"
      return get_purchasing_questions
    when "refinement"
      return get_refinement_questions
    when "tipping"
      return get_tipping_questions
    when "dragonbox"
      return get_dragonbox_questions
    else
      get_scq_questions
    end
  end

  # SCQ
  def get_scq_questions
    Api::V1::PracticeQuestions::DivisionGameSerializer.new(self).as_json[:division_game]
  end

  # Agility
  def get_agility_questions
    Api::V1::PracticeQuestions::AgilityGameSerializer.new(self).as_json[:agility_game]
  end

  # Conversion
  def get_conversion_questions
    Api::V1::PracticeQuestions::ConversionGameSerializer.new(self).as_json[:conversion_game]
  end

  # Diction
  def get_diction_questions
    Api::V1::PracticeQuestions::DictionGameSerializer.new(self).as_json[:diction_game]
  end

  # Discounting
  def get_discounting_questions
    Api::V1::PracticeQuestions::DiscountingGameSerializer.new(self).as_json[:discounting_game]
  end

  # Division
  def get_division_questions
    Api::V1::PracticeQuestions::DivisionGameSerializer.new(self).as_json[:division_game]
  end

  # Estimation
  def get_estimation_questions
    Api::V1::PracticeQuestions::EstimationGameSerializer.new(self).as_json[:estimation_game]
  end

  # Inversion
  def get_inversion_questions
    Api::V1::PracticeQuestions::InversionGameSerializer.new(self).as_json[:inversion_game]
  end

  # Percentages
  def get_percentages_questions
    Api::V1::PracticeQuestions::PercentagesGameSerializer.new(self).as_json[:percentages_game]
  end

  # Proportion
  def get_proportion_questions
    Api::V1::PracticeQuestions::ProportionGameSerializer.new(self).as_json[:proportion_game]
  end

  # Purchasing
  def get_purchasing_questions
    Api::V1::PracticeQuestions::PurchasingGameSerializer.new(self).as_json[:purchasing_game]
  end

  # Refinement
  def get_refinement_questions
    Api::V1::PracticeQuestions::RefinementGameSerializer.new(self).as_json[:refinement_game]
  end

  # Tipping
  def get_tipping_questions
    Api::V1::PracticeQuestions::TippingGameSerializer.new(self).as_json[:tipping_game]
  end

  # Dragonbox
  def get_dragonbox_questions
    Api::V1::PracticeQuestions::DragonboxGameSerializer.new(self).as_json[:dragonbox_game]
  end

  def similar_discussion discussion_type
    return nil if GameLevel.where(practice_mode: practice_mode).where.not(intro_discussion: nil).count == 0
    case discussion_type
    when "introduction"
      return GameLevel.where(practice_mode: practice_mode).where.not(intro_discussion: nil).first.intro_discussion
    when "success"
      return GameLevel.where(practice_mode: practice_mode).where.not(success_discussion: nil).first.success_discussion
    when "failure"
      return GameLevel.where(practice_mode: practice_mode).where.not(fail_discussion: nil).first.fail_discussion
    else
      return GameLevel.where(practice_mode: practice_mode).where.not(intro_discussion: nil).first.intro_discussion
    end
  end
end
