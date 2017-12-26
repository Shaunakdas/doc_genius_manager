class WorkingRule < Game
  has_many :game_holders, as: :game
  has_many :question_types, through: :game_holders
  belongs_to :difficulty_level , optional: true
  def self.list(list_params)
    working_rule_list = WorkingRule.all
    if list_params["search"]
      query = list_params["search"]
      working_rule_list = WorkingRule.search(list_params[:search]).order('created_at DESC')
    elsif list_params["slug"]
      query = list_params["slug"]
      working_rule_list = WorkingRule.search_slug(list_params[:slug]).order('created_at DESC')
    end
    total_count = working_rule_list.count
    page_num = (list_params.has_key?("page"))? (list_params["page"].to_i-1):(0)
    limit = (list_params.has_key?("limit"))? (list_params["limit"].to_i):(10)
    working_rule_list = working_rule_list.drop(page_num * limit).first(limit)
    list_response = {result: working_rule_list, page: page_num+1, limit: limit, total_count: total_count, search: query}
  end
end
