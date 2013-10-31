require 'veto/blocks/abstract_block'

module Veto
	class ListBlock < AbstractBlock
		def initialize
			@items = []
		end

		def add item
			items.push(item)
		end

		def execute *args
			items.each { |item| item.execute(*args) }
		end

		private

		def items
			@items
		end
	end
end