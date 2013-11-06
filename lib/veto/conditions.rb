module Veto
	class Conditions
		CONDITION_KEYS = [:if, :unless].freeze

		def self.reject hash={}
			hash.reject{|k,v| CONDITION_KEYS.include?(k) }
		end

		def self.select hash={}
			hash.select{|k,v| CONDITION_KEYS.include?(k) }
		end

		def self.merge dest_hash, source_hash
			CONDITION_KEYS.inject({}) do |m, k|
				c = []
				c << dest_hash[k]
				c << source_hash[k]
				m[k] = c.flatten.compact
				m
			end
		end
	end
end