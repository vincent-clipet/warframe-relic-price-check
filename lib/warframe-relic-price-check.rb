require_relative 'utils/warframe_market_utils'
require_relative 'utils/warframe_wiki_utils'
require_relative '../config/config.rb'





# Logging
logger = Config::LOGGER





# Load what we need from Warframe.market & Wiki
WarframeMarketUtils.load_all_items()
logger.info("All items loaded")
WarframeWikiUtils.load_all_relics()
logger.info("All relics loaded")
vaulted = WarframeWikiUtils.get_vaulted_relics_names()
logger.info("All vaulted relics loaded")



# Link all items to their relics
Relic.all.values.each do | relic |
	logger.debug("relic : #{relic.name}")
	relic.vaulted = vaulted.include?(relic.name)
	relic.items.each do | item_name |
		logger.debug("item_name : #{item_name}")
		item = Item.find(item_name)
		item.add_relic(relic) unless item.nil?
	end
end



# Save to HTML
f = File.open("../assets/index.html", 'w')
f.puts(File.readlines("../assets/top.html"))
values = Item.all.values.sort_by { | item | [item.name] }
values.each do | item |
	f.puts(item.to_html())
end
f.puts(File.readlines("../assets/bottom.html"))
logger.info("File '../assets/index.html' saved.")
f.close()



# Extract the tier-list of relics for platinum gains
f2 = File.open("../assets/tier-list.csv", "w")
f2.puts("relic;avg plat (intact);avg plat (intshare);avg plat (radiant);avg plat (radshare 4)")

vaulted = WarframeWikiUtils.get_vaulted_relics_names()

Relic.all.values.each do | relic |

	next if vaulted.include?(relic.name)

	rng_plat_intact = 0
	rng_plat_intshare = 0
	rng_plat_radiant = 0
	rng_plat_radshare = 0
	nb = 0

	relic.items.each do | item_name |

		next if item_name.include?("Forma Blueprint")

		item = Item.find(item_name)

		if item.nil?
			logger.warn("'#{item_name}' does not exist !")
			next
		end

		reward_tier = relic.get_reward_tier(item_name)
		nb = nb + 1

		if reward_tier == "bronze"
			rng_plat_intact = rng_plat_intact + item.plats * 0.2533
			rng_plat_intshare = rng_plat_intshare + item.plats * 0.07763184
			rng_plat_radiant = rng_plat_radiant + item.plats * 0.1667
			rng_plat_radshare = rng_plat_radshare + item.plats * 0.0625
		elsif reward_tier == "silver"
			rng_plat_intact = rng_plat_intact + item.plats * 0.11
			rng_plat_intshare = rng_plat_intshare + item.plats * 0.60596191
			rng_plat_radiant = rng_plat_radiant + item.plats * 0.20
			rng_plat_radshare = rng_plat_radshare + item.plats * 0.5936
		elsif reward_tier == "gold"
			rng_plat_intact = rng_plat_intact + item.plats * 0.02
			rng_plat_intshare = rng_plat_intshare + item.plats * 0.31640625
			rng_plat_radiant = rng_plat_radiant + item.plats * 0.10
			rng_plat_radshare = rng_plat_radshare + item.plats * 0.3439
		end
	end

	f2.puts("#{relic.name};#{rng_plat_intact.round(3)};#{rng_plat_intshare.round(3)};#{rng_plat_radiant.round(3)};#{rng_plat_radshare.round(3)}")
end

f2.close()
logger.info("File '../assets/tier-list.csv' saved.")
