module Veto
	class VetoError < StandardError; end
	class InvalidEntity < VetoError; end
end