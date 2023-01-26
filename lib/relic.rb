class Relic



	attr_accessor :name, :tier, :type, :items, :vaulted
	@@all = {}



	def initialize(hash)
		@name = hash["fullname"]
		@tier = hash["tier"]
		@type = hash["type"]
		@items = hash["items"]
		@vaulted = true
		@@all[@name] = self
	end



	def contains?(item_name)
		return false if item_name.nil?
		return @items.include?(item_name)
	end



	def get_reward_tier(item_name)
		return nil unless contains?(item_name)
		
		item_index = @items.index(item_name)
		if item_index <= 2
			return "bronze"
		elsif item_index == 3 || item_index == 4
			return "silver"
		elsif item_index == 5
			return "gold"
		end	
	end



	def self.all()
		return @@all
	end

	def to_s()
		return "#{@name}\t#{@items.join(', ')}}"
	end



end