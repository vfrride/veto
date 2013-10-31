require 'veto/blocks/list_block'

module Veto
	class ConditionalListBlock < ListBlock
		def initialize condition_proc
			@condition_proc = condition_proc
			super()
		end

		def execute *args
			if condition_proc.call(*args)
				items.each { |item| item.execute(*args) }
			end
		end

		private

		def condition_proc
			@condition_proc
		end
	end
end