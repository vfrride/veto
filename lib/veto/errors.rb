module Veto
	class Errors < ::Hash
		ATTRIBUTE_JOINER = ' and '.freeze

		def add(att, msg)
			fetch(att){self[att] = []} << msg
		end

		def count
			values.inject(0){|m, v| m + v.length}
		end

		def empty?
			count == 0
		end

		def full_messages
			inject([]) do |m, kv| 
				att, errors = *kv
				errors.each {|e| m << "#{att} #{e}"}
				m
			end
		end

		def on(att)
			if v = fetch(att, nil) and !v.empty?
				v
			end
		end
	end
end