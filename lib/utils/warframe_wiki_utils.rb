require_relative '../relic'
require 'nokogiri'

module WarframeWikiUtils



	def self.load_all_relics()

		http_get = HttpUtils.get("https://warframe.fandom.com/wiki/Void_Relic/ByRelic?action=render")
		html = Nokogiri::HTML(http_get)

		html.css("body > table > tr")[1..-1].each do | tr |

			tds = tr.css("td")

			relic_name = "#{tds[0].text[1..-1].gsub("\n", "")} #{tds[1].text[1..-1].gsub("\n", "")}"
			Relic.new({
				"fullname" => relic_name,
				"tier" => tds[0].text[1..-1].gsub("\n", ""),
				"type" => tds[1].text[1..-1].gsub("\n", ""),
				"items" => [
					clean_item_names(tds[2].css("li")[0].text),
					clean_item_names(tds[2].css("li")[1].text),
					clean_item_names(tds[2].css("li")[2].text),
					clean_item_names(tds[3].css("li")[0].text),
					clean_item_names(tds[3].css("li")[1].text),
					clean_item_names(tds[4].css("li")[0].text)
				]
			})
		end
	end



	def self.get_vaulted_relics_names()

		http_get = HttpUtils.get("https://warframe.fandom.com/wiki/Void_Relic")
		html = Nokogiri::HTML(http_get)

		vaulted = []
		html.css("#mw-customcollapsible-VaultedRelicList > table > tr:nth-child(2) > td > ul > li > span > a").each do | a |
			vaulted << a.text.gsub("\n", "").lstrip().rstrip()
		end

		html.css("#mw-customcollapsible-BaroRelicList > table > tr:nth-child(2) > td > ul > li > span > a").each do | a |
			vaulted << a.text.gsub("\n", "").lstrip().rstrip()
		end
		
		return vaulted
	end



	private



	def self.clean_item_names(item_name)

		# Remove new line character
		s = item_name.gsub("\n", "")

		# Remove leading & trailing whitespaces
		s = s.rstrip().lstrip()

		# Replace "&" by "and" for compatibility
		s = s.gsub(/&/, "and")

		# Remove useless "blueprint" keywords
		regex_match = s.match(/^(.*)(Systems|Chassis|Neuroptics)( Blueprint)$/)
		unless regex_match.nil?
			s = regex_match.captures[0..1].join
		end

		return s
	end



end