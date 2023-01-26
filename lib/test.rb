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
