require 'minitest/autorun'
require 'mocha/setup'
require 'veto'

def context *args, &block
  describe *args, &block
end