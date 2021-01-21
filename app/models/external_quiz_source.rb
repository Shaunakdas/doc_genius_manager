require 'open-uri'
class ExternalQuizSource < ApplicationRecord
  has_many :external_questions
  belongs_to :game_holder, optional: true
  def create_game_holder
    if game_holder
      puts "ExternalQuizSource #{id} GameHolder already exists"
      return game_holder
    end
    game = PracticeType.find_by(slug: "agility")
    g_h = GameHolder.create!(:name => title,
      :slug => title.parameterize(separator: '-')+'-'+((0...3).map { ('a'..'z').to_a[rand(26)] }.join),
      title: title,
      game: game,
      image_url: s3_image_url)
    update_attributes!(game_holder: g_h)
    return g_h
  end

  def move_asset_to_s3
    return nil if image_url.nil?
    update_attributes!(s3_image_url: ExternalQuizSource.upload_to_s3(image_url))
    puts "Uploaded file to #{s3_image_url}"
    external_questions.each do |question|
      question.move_asset_to_s3
    end
  end

  def self.create_game_holder_bulk
    ExternalQuizSource.all.each do |quiz|
      quiz.create_game_holder
      quiz.external_questions.all.each do |ques|
        ques.create_question
      end
    end
  end

  def self.upload_quiz_to_s3_bulk
    ExternalQuizSource.all.each do |quiz|
      quiz.move_asset_to_s3
    end
  end

  def self.upload_to_s3 public_url
    return nil if public_url.nil?
    return nil if public_url == "https://cf.quizizz.com/img/logos/new/logo_placeholder_sm.png"
    endpoint = public_url.split("?")[0]
    return nil if !public_url.include? "quizizz-media/"
    file_type = (public_url.include? "_audio" )? ".mp3" : ".png"
    key = "media/resources/" + public_url.split("quizizz-media/")[1].split("?")[0] + file_type
    public_url = public_url.split("?")[0]+"?w=400&h=400"
    # Uncomment when this line is added to Gemfile
    # gem 'aws-sdk-s3'
    # client = Aws::S3::Client.new(region: 'ap-south-1')
    # resource = Aws::S3::Resource.new(client: client)
    # bucket_name = "drona-player.docgenius.in"
    # begin
    #   puts "Checking if key: #{key} exists?"
    #   client.get_object(bucket: bucket_name, key: key)
    # rescue Aws::S3::Errors::NoSuchKey
    #   begin
    #     puts "Before upload: key: #{key}, public_url: #{public_url}"
    #     client.put_object(bucket: bucket_name, key: key, body: open(public_url).read)
    #   rescue OpenURI::HTTPError => ex
    #     puts "Not avilable asset : #{ex}"
    #     key = nil
    #   end
    # end 
    return key
  end
end
