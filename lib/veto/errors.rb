module Veto
	class Errors < ::Hash
		def add attribute, message
			fetch(attribute){self[attribute] = []} << message
		end

		def count
			values.inject(0){|memo, value| memo + value.length}
		end

		def empty?
			count == 0
		end

		def full_messages
			inject([]) do |memo, kv| 
				attribute, errors = *kv
				errors.each {|e| memo << "#{attribute} #{e}"}
				memo
			end
		end

		def on(attribute)
			if value = fetch(attribute, nil) and !value.empty?
				value
			end
		end
	end
end