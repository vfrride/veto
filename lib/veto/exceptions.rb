module Veto
	class VetoError < StandardError; end
	class InvalidEntity < VetoError; end
	class ValidatorNotAssigned < VetoError; end
end