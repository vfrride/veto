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
			CONDITION_KEYS.inject({}) do |memo, key|
				cond = []
				cond << dest_hash[key]
				cond << source_hash[key]
				memo[key] = cond.flatten.compact
				memo
			end
		end
	end
end