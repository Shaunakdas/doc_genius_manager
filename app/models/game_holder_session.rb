class GameHolderSession < ApplicationRecord
  belongs_to :game_holder
  belongs_to :user
  enum completion_status: [ :created, :started, :completed]
  enum attempt_type: [ :homework, :permanent, :live]



  def self.search(search)
    where('upper(title) LIKE :search', search: "%#{search.upcase}%")
  end

  def self.list(list_params)
    session_list = GameHolderSession.all

    # Filtering Options
    if list_params["search"]
      query = list_params["search"]
      session_list = GameHolderSession.search(list_params[:search])
    end

    # Owned by me
    session_list = session_list.where(generated_by: User.find(list_params[:user_id])) if list_params["generated_by"] && list_params["generated_by"] == "me" 

    # Sorting Params
    sort_by_created = "desc"
    sort_by_created = list_params["sort_order"] if list_params["sort_order"]
    if list_params["sort_by"] && list_params["sort_by"] == "title"  
      session_list = session_list.order('title ASC') 
    else
      session_list = session_list.order('created_at '+sort_by_created) 
    end
    
    # Pagination Order
    total_count = session_list.count
    page_num = (list_params.has_key?("page"))? (list_params["page"].to_i-1):(0)
    limit = (list_params.has_key?("limit"))? (list_params["limit"].to_i):(10)
    session_list = session_list.drop(page_num * limit).first(limit)
    list_response = {result: session_list, page: page_num+1, limit: limit, total_count: total_count, search: query}
  end

end
