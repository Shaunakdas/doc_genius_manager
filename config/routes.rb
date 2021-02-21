Rails.application.routes.draw do

  # devise_for :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      # Handling Options call for all apis
      match '*path', via: [:options], to:  lambda {|_| [204, {'Content-Type' => 'text/plain'}, []]}
      
      # Users
      # Get Users List using search, filter and pagination. Req: (Admin Auth token, Role, Standard, Region, TargetExam, Query, Board, Page, Limit). Response: (User Array)
      get "users" => "users#index"
      # Create User. Req: (Admin Auth token, Name, Email, Username, Mobile, OAuth/Password, Age). Response: (Auth token)
      post "users" => "users#create"
      # Get User Details. Req: (Admin Auth token, id, login)
      get "user/:id" => "users#details"
      # Get User Details. Req: (Auth token)
      get "user/me" => "users#me"
      # Updates User Details. Req: (Auth token)
      put "user/:id" => "users#update"
      # User Invite . Create User
      post "user/invite" => "users#invite"
      # Image Upload(Will take username or email)
      post "photo/profile" => "users#photo_upload"
      # Delete User Req: (Admin AuthToken, User Id)
      delete "user/:id" => "users#delete"
      
      # resources :users  do 
      #   collection do
      #     get 'users' => 'users#index'
      #     get 'first' => 'users#show'
          
      #   end
      # end

      # Standards
      # Get Standards List using search, filter and pagination. Req: (Auth token, Role, Standard, Region, TargetExam, Query, Board, Page, Limit). Response: (Standard Array)
      get "standards" => "standards#index"
      # Create Standard. Req: (Auth token, Name, Email, Standardname, Mobile, OAuth/Password, Age). Response: (Auth token)
      post "standards" => "standards#create"
      # Get Standard Details. Req: (Auth token, id, login)
      get "standard/:id" => "standards#details"
      # Updates Standard Details. Req: (Auth token)
      put "standard/:id" => "standards#update"
      # Delete Standard Req: (Admin AuthToken, User Id)
      delete "standard/:id" => "standards#delete"
      # HomePage Req: ( AuthToken)
      get "homepage" => "standards#homepage"
      # HomePage 
      get "home" => "standards#home"
      # LevelMap Req: ( AuthToken)
      get "map" => "standards#level_map"
      # Streamwise Questions Req: ( AuthToken)
      get "question_types/all" => "standards#streamwise_questions"

      # Chapters
      # Get Chapters List using search, filter and pagination. Req: (Auth token, Role, Standard, Region, TargetExam, Query, Board, Page, Limit). Response: (Standard Array)
      get "chapters" => "chapters#index"
      # Get Chapters List using search, filter and pagination. Req: (Auth token, Role, Standard, Region, TargetExam, Query, Board, Page, Limit). Response: (Standard Array)
      get "chapter_list" => "chapters#list"
      # Get Chapters List using search, filter and pagination. Req: (Auth token, Role, Standard, Region, TargetExam, Query, Board, Page, Limit). Response: (Standard Array)
      get "topic_levels" => "chapters#topicwise_levels"

      # resources :standards  do 
      #   collection do
      #   end
      # end



      # QuestionType
      # Get QuestionType List using search, filter and pagination. Req: (Auth token, Role, QuestionType, Region, TargetExam, Query, Board, Page, Limit). Response: (QuestionType Array)
      get "question_types" => "question_types#index"
      # Create QuestionType. Req: (Auth token, Name, Email, QuestionTypename, Mobile, OAuth/Password, Age). Response: (Auth token)
      post "question_types" => "question_types#create"
      # Get QuestionType Details. Req: (Auth token, id, login)
      get "question_type/:id" => "question_types#details"
      # Updates QuestionType Details. Req: (Auth token)
      put "question_type/:id" => "question_types#update"
      # Delete QuestionType Req: (Admin AuthToken, User Id)
      delete "question_type/:id" => "question_types#delete"
      # HomePage Req: (Admin AuthToken)
      get "question_type/:id/show" => "question_types#show"
      # Edit Working rule Question Text. Req: (id, rule_id, question_text)
      post "question_type/:id/working_rule/:rule_id/edit" => "question_types#edit_working_rule"
      # Add Working rule Question Text. Req: (id, rule_id, question_text)
      post "add_working_rule" => "question_types#add_working_rule"

      # Question
      # Update Acad Entity(GameQuestion, GameOption, Hint, Hintcontent) Details
      put "question/update" => "questions#update"
      # Get GameQuestion Details
      get "question/:id/details" => "questions#details"
      # Get GameOption Details
      get "question/option/:id/details" => "questions#option_details"
      # GET Question Structure
      get "question/:game_id/structure" => "questions#structure"
      # POST Create question for a game
      post "question/:game_id/create" => "questions#create"
      # POST Create option for a question
      post "question/:game_question_id/option" => "questions#create_option"
      # POST Create question for a parent_question
      post "question/:game_question_id/child" => "questions#create_child_question"
      # POST Delete question for a parent_question
      put "question_delete/:game_question_id/:status" => "questions#delete_question"
      # POST Delete option for a question
      put "option_delete/:game_option_id/:status" => "questions#delete_option"

      # GameSession
      # Get GameSession List using search, filter and pagination. Req: (Auth token, Role, GameSession, Region, TargetExam, Query, Board, Page, Limit). Response: (GameSession Array)
      get "game_sessions" => "game_sessions#index"
      # Create GameSession. Req: (Auth token, Name, Email, GameSessionname, Mobile, OAuth/Password, Age). Response: (Auth token)
      post "game_session" => "game_sessions#create"
      # Get GameSession Details. Req: (Auth token, id, login)
      get "game_session/:id" => "game_sessions#details"

      # Game Holder
      # Get Game Holders List using search, filter and pagination. Req: (Auth token, Role, Standard, Region, TargetExam, Query, Board, Page, Limit). Response: (Standard Array)
      get "games" => "game_holders#index"
      # Get GameHolder Details for Start Screen. Req: (Game Holder Id, Auth Token). Response: (Game Holder Details)
      get "game/:id/details" => "game_holders#details"
      get "game/:id/level_details" => "game_holders#level_details"
      # Post Result of GameHolder attempts at Game End Screen. Req: (Game Holder Id, Auth Token). Response: (Game Holder Details)
      post "game/result" => "game_holders#result"
      # Post Result of GameLevel attempts at Game End Screen. Req: (Game Holder Id, Auth Token). Response: (Game Holder Details)
      post "game/level_result" => "game_holders#level_result"
      # Post Result of GameLevel attempts at Game End Screen. Req: (Game Holder Id, Auth Token). Response: (Game Holder Details)
      post "game/session_result" => "game_holders#session_result"
      # upload excel for game_holders
      post "game/upload_file" => "game_holders#upload_file"
      # Create Game
      post "game" => "game_holders#create"
      # Update Game
      put "game/:id" => "game_holders#update"
      # user can take action
      get "game/:id/action/:action_type" => "game_holders#user_action"

      
      # Reports


      # Game Holder Session
      # Get Game Holder Sessions List using search, filter and pagination. Req: (Auth token, Role, Standard, Region, TargetExam, Query, Board, Page, Limit). Response: (Standard Array)
      get "reports" => "game_holder_sessions#index"
      # Get GameHolder Session Details for Start Screen. Req: (Game Holder Id, Auth Token). Response: (Game Holder Details)
      get "report/:id" => "game_holder_sessions#summary"
      # Get GameHolder Session Details for Start Screen. Req: (Game Holder Id, Auth Token). Response: (Game Holder Details)
      get "report/:id/details" => "game_holder_sessions#details"
      # Get GameHolder Session Details for Start Screen. Req: (Game Holder Id, Auth Token). Response: (Game Holder Details)
      post "reports/create" => "game_holder_sessions#create"
      # Get GameHolder Session Details for Start Screen. Req: (Game Holder Id, Auth Token). Response: (Game Holder Details)
      put "report/:id" => "game_holder_sessions#edit"
      # Registrations
      # Sign up User by Number. Req: (Mobile  Number, Password). Response: (Auth Token)
      # post "registrations/sign_up_number" => "registrations#sign_up_number"
      post "sign_up/email" => "registrations#sign_up_email"
      # Guest Sign Up. Req: (Guest Name). Response: (Auth Token)
      post "sign_up/guest" => "registrations#sign_up_guest"
      post "sign_up/phone" => "registrations#sign_up_phone"
      get "verify/otp" => "registrations#verify_otp"
      # Activate User by verifying OTP. Req: (Number, OTP). Response: (Auth Token)
      post "activate" => "registrations#activate"
      # Fill User Details. Req: (Auth Token, First Name, Last Name, Date of birth, Sex, EMail, First Time). Response: (Success)
      put "fill_form" => "registrations#update"
      # Get User details. Req: (Auth Token, First Name, Last Name, Date of birth, Sex, EMail, First Time). Response: (Success)
      get "me" => "registrations#details"
      # Login User using Mobile Number. Req: (Mobile Number, Password). Response: (Auth Token)
      post "login/email" => "registrations#login_email"
      # Logout User. Req: (Auth token). Response: ()
      post "logout" => "registrations#logout"

      # resources :registrations  do 
      #   collection do
      #   end
      # end

      # VictoryCard
      # Get VictoryCard List
      get "victory_cards" => "victory_cards#index"
      
      # Passwords
      # Forgot Password. Req: (Login). Response: ()
      post "password/forgot" => "passwords#forgot"
      # Reset Password. Req: (Username, OTP). Response: ()
      post "password/reset" => "passwords#reset"
      # Modify Password. Req: (Login, New Password). Response: (Auth Token)
      put "password/modify" => "passwords#modify"
      
      # resources :passwords  do 
      #   collection do
      #   end
      # end
      
    end
  end
  
  def handle_options_request
    head(:ok) if request.request_method == "OPTIONS"
  end
end
  
  


