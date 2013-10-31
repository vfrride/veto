module Veto
	class AbstractBlock
		def add
			raise NotImplementedError
		end

		def execute
			raise NotImplementedError
		end
	end
end