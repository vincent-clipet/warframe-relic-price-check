require 'json'
require 'rest-client'
require_relative '../../config/config.rb'



module HttpUtils



	def self.get(url)
		begin
			ret = RestClient.get(url, {:user_agent => Config::USER_AGENT})
			Config::LOGGER.debug("#{url} GET")
			return ret
		rescue RestClient::ExceptionWithResponse => exc
			Config::LOGGER.error("#{url}")
			Config::LOGGER.error("#{exc.http_code}")
			Config::LOGGER.error("#{exc.message}")
			return nil
		end
	end



	def self.get_json(url)
		json = nil
		begin
			json = RestClient.get(url, {:user_agent => Config::USER_AGENT, accept: :json}).to_s
			Config::LOGGER.debug("#{url}.json GET")
			return JSON.parse(json)
		rescue RestClient::ExceptionWithResponse => exc
			Config::LOGGER.error("#{url}")
			Config::LOGGER.error("#{exc.http_code}")
			Config::LOGGER.error("#{exc.message}")
			return nil
		rescue NoMethodError => exc
			Config::LOGGER.error("#{url}")
			Config::LOGGER.error("#{exc.message}")
			return nil
		end
	end



end