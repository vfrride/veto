require 'veto/version'
require 'veto/model'
require 'veto/validator'
require 'veto/configuration'

module Veto

	# Provides access to the anonymous validator extension module
	#
	# @example 
	# 	class PersonValidator
	#    include Veto.validator
	# 	end	
	#
	# @return [Module] the object converted into the expected format.
	def self.validator
		mod = Module.new
		mod.define_singleton_method :included do |base|
			base.send(:include, ::Veto::Validator)
		end
		mod
	end

	# Provides access to the anonymous model extension module
	#
	# @example 
	# 	class Person
	#    include Veto.model(PersonValidator)
	# 	end	
	#
	# @param validator [Class] the Veto validator class
	# @return [Module] the object converted into the expected format.
	def self.model validator
		mod = Module.new
		mod.define_singleton_method :included do |base|
			base.send(:include, ::Veto::Model)
			base.validates_with validator
		end
		mod
	end

	def self.configure
		yield(configuration)
	end

	def self.configuration
		@configuration ||= ::Veto::Configuration.new
	end

	def self.configuration= val
		@configuration = val
	end
end