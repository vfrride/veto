require 'minitest/autorun'
require 'mocha/setup'

def context *args, &block
	describe *args, &block
end