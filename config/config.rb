require 'logger'

module Config

	WARFRAME_MARKET_DELAY = 2

	LOG_LEVEL = Logger::INFO

	USER_AGENT = "warframe-relic-price-check/1.0 (+https://github.com/vincent-clipet/)"



	# Logging
	LOGGER = Logger.new(STDOUT)
	LOGGER.formatter = proc {|severity, datetime, progname, msg| "[#{severity}] #{msg}\n" }
	LOGGER.level = LOG_LEVEL

end