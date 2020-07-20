
def parse_algebra
  require "json"
  file = File.open "db/seeds/algebra_items.json"
  data = JSON.load file
  puts data["items"][0]["id"]
  if !data["items"].nil?
    data["items"].each do |item|
      reference_id = item["id"]
      display = item["display"]
      value_type = item["type"]
      positive = item["positive"]
      puts " reference_id: #{reference_id} display: #{display} value_type: #{value_type} positive: #{positive} "
      create_option(reference_id, display, value_type, positive)
    end
  end

end

def create_option reference_id, display, value_type, positive
  option = Option.where(reference_id: reference_id).first
  if option.nil?
    option = Option.create!( reference_id: reference_id, display: display, value_type: value_type, positive: positive)
  else
    option.update_attributes!( display: display, value_type: value_type, positive: positive)
  end
  return option
end

# parse_algebra