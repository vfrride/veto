#Veto is a lightweight gem that provides familiar validations for plain old ruby objects.


require 'veto/version'
require 'veto/model'
require 'veto/validator'

module Veto



	def self.model validator
		mod = Module.new
		mod.define_singleton_method :included do |base|
			base.send(:include, ::Veto::Model)
			base.validates_with validator
		end
		mod
	end

	def self.validator
		mod = Module.new
		mod.define_singleton_method :included do |base|
			base.send(:include, ::Veto::Validator)
		end
		mod
	end
end