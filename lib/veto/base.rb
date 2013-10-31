require 'veto/errors'
require 'veto/exceptions'

module Veto
	class Base
		# class << self
		# 	# def valid? entity
		# 	# 	new(entity).valid?
		# 	# end

		# 	# def validate! entity
		# 	# 	new(entity).validate!
		# 	# end

		# 	def validate_presence_of attr attr attr
		# 		attr.each do |a|
		# 			PresenceValidator.
		# 		end
		# 	end

		# 	def validate_exact_length_of len, attr, attr, attr
		# 		attrs.each do |attr|
		# 			validates attr, :exact_length => len
		# 		end
		# 	end

		# 	def validate_min_length_of len, attr, attr, attr
			
		# 	end

		# 	def validate_max_length_of len, attr, attr, atre

		# 	end

		# 	def validates attr, options
		# 	end

		# 	def validate :meth_name
		# 	end
		# end

		def self.validates attribute_name, validations_hash={}

		end

		def self.validators
			@validators ||= []
		end

		def self.valid? entity
			new(entity).valid?
		end

		def self.validate! entity
			new(entity).validate!
		end

		attr_reader :entity

		def initialize entity
			@entity = entity
		end

		def errors
			@errors ||= ::Veto::Errors.new
		end

		def valid?
			validate
			errors.empty?
		end

		def validate!
			raise(::Veto::InvalidEntity, errors.full_messages) unless valid?
		end

		private

		def validate
			# TODO initiate validation process here...
		end
	end
end