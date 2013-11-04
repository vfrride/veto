module Veto
	class VetoError < StandardError; end
	class InvalidEntity < VetoError; end
	class CheckerNotAssigned < VetoError; end
end