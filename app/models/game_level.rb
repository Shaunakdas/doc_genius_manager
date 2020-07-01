class GameLevel < ApplicationRecord
  belongs_to :game_holder
  belongs_to :intro_discussion, class_name: "CharacterDiscussion", optional: true
  belongs_to :success_discussion, class_name: "CharacterDiscussion", optional: true
  belongs_to :fail_discussion, class_name: "CharacterDiscussion", optional: true
  # :id, :title, :sub_title, :name, :slug, :sequence, :game, :image_url, :enabled
  has_many :game_level_victory_cards
  has_many :victory_cards, through: :game_level_victory_cards
  has_many :game_level_victory_cards
  has_one :score_structure
  has_many :game_sessions
  has_many :game_questions
  has_one :linked_victory_card, as: :acad_entity, class_name: "VictoryCard"
  has_many :attempt_scores, through: :game_sessions
  has_many :benifits

  has_many :game_questions, -> { order('difficulty_index asc') }

  enum practice_mode: [ :introduction, :learning, :practice]
  enum nature_effect: [ :rain, :lightning, :mist, :snow, :leaves ]

  def self.search(search)
    where('name LIKE :search', search: "%#{search}%")
  end

  def sub_title
    return game_holder.sub_title if description.nil?
    return description
  end

  def enabled
    game_holder.enabled
  end

  def game
    game_holder.game
  end

  def set_attempt_standing user
    level_standing = user.level_standing
    if level_standing.nil?
      level_standing = AcadStanding.new(acad_entity: self, user: user).save!
    else
      level_standing.update_attributes!(acad_entity: self)
    end
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
    return game_level_victory_cards if game_level_victory_cards.count > 0
    # return victory_cards if victory_cards.count != 0 
    return [VictoryCard.get_default.game_level_victory_card]
  end

  def parse_result user, result_json
    session = GameSession.create!(user: user, start: Time.now, game_level: self, game_holder: game_holder)
    session.parse_result(result_json)
    return session
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

  def sub_questions
    list = []
    game_questions.each do |g_q|
      g_q.sub_questions.each do |s_q|
        list << s_q
      end
    end
    return list
  end

  def background_area
    return game_holder.acad_entity.background_area
  end

  def remove_game_questions
    game_questions.each do |ques|
      ques.update_attributes!(game_level: nil)
    end
  end

  def user_ranking
    sorted_scores = attempt_scores.sort_by{|score| score.total_value}.reverse
    uniq_scores = []
    sorted_scores.each do |score|
      user = score.attempt_item.user
      uniq_scores << { user_id: user.id,
        username: user.first_name, 
        score_value: score.total_value} 
    end
    return uniq_scores.uniq{|x| x[:user_id]}
  end

  def next_game_level
    enabled_levels = game_holder.acad_entity.chapter.practice_game_levels
    current_index = enabled_levels.index(self)+1
    return nil if enabled_levels.length == current_index
    return enabled_levels[current_index]
  end

  def next_topic_level
    enabled_levels = game_holder.acad_entity.practice_game_levels
    current_index = enabled_levels.index(self)+1
    return nil if enabled_levels.length == current_index
    return enabled_levels[current_index]
  end

  def next_game_levels
    enabled_levels = game_holder.acad_entity.chapter.practice_game_levels
    current_index = enabled_levels.index(self)
    return enabled_levels[current_index+1..-1]
  end

  def all_character_discussions
    [intro_discussion, success_discussion, fail_discussion]
  end
end
