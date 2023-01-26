class Item



	attr_accessor :name, :id, :url, :plats, :ducats, :ratio, :relics
	@@all = {}



	def initialize(name, id, url, plats, ducats, ratio)
		@name = name
		@id = id
		@url = url
		@plats = plats
		@ducats = ducats
		@ratio = ratio
		@relics = []
		@@all[name] = self
	end



	def add_relic(relic)
		@relics.each do | r |
			return if r.name == relic.name # in case of duplicates; not supposed to happen
		end
		@relics << relic
	end

	def sort_relics()
		@relics.sort_by! { | relic | [relic.name] }
	end



	def self.all()
		return @@all
	end

	def self.find(item_name)
		# return nil if item_name.include?("Forma")
		return nil unless @@all.has_key?(item_name)
		return @@all[item_name]
	end



	def get_relics_names()
		ret = []
		@relics.each do | relic |
			ret << relic.name
		end
		return ret.join(",")
	end

	def to_s()
		return "#{@name}\t#{@id}\t#{@url}\t#{@plats}\t#{@ducats}\t#{@ratio}\t#{get_relics_names()}"
	end

	def to_html()

		ret = []
		sort_relics()

		@relics.each do | relic |
			next if @name.include?("Forma Blueprint")

			reward_tier = relic.get_reward_tier(@name)
			ret << "\t\t\t\t\t<tr class='blueprint' id='#{@id}-#{relic.type}-#{relic.tier}'>"
			ret << "\t\t\t\t\t\t<td class='item_name'><a href='https://warframe.market/items/#{@url}' target='_blank'><span class='#{reward_tier}'>#{@name}</span></a></td>"
			ret << "\t\t\t\t\t\t<td class='plats'>#{@plats}</td>"
			ret << "\t\t\t\t\t\t<td class='ratio'>#{@ratio}</td>"
			ret << "\t\t\t\t\t\t<td class='ducats'>#{@ducats}</td>"
			# ret << "\t\t\t\t\t\t<td class='relic'" + (relic.vaulted ? " class='vaulted'" : "") + "><a href='https://warframe.fandom.com/wiki/#{relic.name.gsub(" ", "_")}' target='_blank'>#{relic.name}</a></td>"
			# ret << "\t\t\t\t\t\t<td class='relic'><a href='https://warframe.fandom.com/wiki/#{relic.name.gsub(" ", "_")}' target='_blank'>#{relic.name}#{relic.vaulted ? " (v)" : ""}</a></td>"
			ret << "\t\t\t\t\t\t<td class='relic'><a href='https://warframe.fandom.com/wiki/#{relic.name.gsub(" ", "_")}' target='_blank'>#{relic.name}</a></td>"
			ret << "\t\t\t\t\t\t<td#{relic.vaulted ? " class='vaulted'>V" : ">"}</td>"
			ret << "\t\t\t\t\t\t<td class='add_to_opened' onclick='add_to_opened(\"#{@id}-#{relic.type}-#{relic.tier}\")' title='Add to opened relics list'>+</td>"
			ret << "\t\t\t\t\t</tr>"
		end

		return ret.join("\n")
	end



end