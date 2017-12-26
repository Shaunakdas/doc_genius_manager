FactoryGirl.define do
  factory :game_session do
    start {Faker::Time.between(DateTime.now - 1, DateTime.now)}
    finish {Faker::Time.between(DateTime.now - 1, DateTime.now)}
    game_holder_id {FactoryGirl.create(:game_holder).id}
    user_id {FactoryGirl.create(:user).id}
    # session_score {FactoryGirl.attributes_for(:session_score)}
    # association :session_score, factory: :session_score
    # association :game_holder, factory: :game_holder
    # association :user, factory: :user
  end

end
