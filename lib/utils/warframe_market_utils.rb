require 'json'
require_relative '../item'
require_relative './http_utils'

module WarframeMarketUtils



	def self.load_all_items()
		
		# Get item names, URL & id
		url = "https://api.warframe.market/v1/items"
		json = HttpUtils.get_json(url)
		all_items_by_id = {}

		json["payload"]["items"].each do | item |
			id = item["id"]
			name = item["item_name"].gsub("&", "and")
			url = item["url_name"]
			all_items_by_id[id] = { "name" => name, "url" => url}
		end

		# Get item prices in ducats & plats
		url = "https://api.warframe.market/v1/tools/ducats"
		json = HttpUtils.get_json(url)

		json["payload"]["previous_day"].each do | item |
			id = item["item"]
			plats = item["wa_price"].to_f
			ducats = item["ducats"].to_i
			ratio = item["ducats_per_platinum_wa"].to_f
			item_name = all_items_by_id[id]["name"]
			item_url = all_items_by_id[id]["url"]
			Item.new(item_name, id, item_url, plats, ducats, ratio)
		end
	end



end