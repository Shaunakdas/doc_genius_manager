require 'rails_helper'

RSpec.describe Standard, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:standard)).to be_valid
  end
  describe "Associations" do
    it { should have_many(:chapters) }
    it { should have_many(:topics) }
    it { should have_many(:sub_topics) }
    it { should have_many(:question_types) }
  end
  describe "Acad Profile Associations" do
    it { should have_many(:acad_profiles) }
    it { should have_many(:users) }
    it { should have_many(:acad_entity_scores) }
    it { should have_many(:region_percentile_scores) }
  end
  trait :question_types do
    chapters = FactoryGirl.create_list(:chapter, 2)
    chapters.each do |chapter|
      chapter.standard = std
      chapter.sequence_stream = Random.rand(200)
      chapter.save!
      puts chapter.to_json
      topics = FactoryGirl.create_list(:topic, 2)
      topics.each do |topic|
        topic.chapter = chapter
        topic.sequence = Random.rand(200)
        topic.save!
        sub_topics = FactoryGirl.create_list(:sub_topic, 2)
        sub_topics.each do |sub_topic|
          sub_topic.topic = topic
          sub_topic.sequence = Random.rand(200)
          sub_topic.save!
          question_types = FactoryGirl.create_list(:question_type, 2)
          question_types.each do |question_type|
            question_type.sub_topic = sub_topic
            question_type.sequence = Random.rand(200)
            question_type.save!
            puts question_type.to_json
          end
        end
      end
    end
  end
end
