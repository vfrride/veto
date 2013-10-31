module Veto
	class ValidatorList
		def add *args
			validator_list.push(*args)
			true
		end

		def validate *args
			validator_list.each { |validator| validator.validate(*args) }
		end

		private

		def validator_list
			@validator_list ||= []
		end
	end
end