module Veto
  class Configuration
    class Message
      DEFAULT_MESSAGES = {
        :default                  => lambda {"is not valid"},
        :exact_length             => lambda {|exact| "is not #{exact} characters"},
        :format                   => lambda {"is not valid"},
        :greater_than             => lambda {|boundary| "must be greater than #{boundary}"},
        :greater_than_or_equal_to => lambda {|boundary| "must be greater than or equal to #{boundary}"},
        :inclusion                => lambda {|set| "is not in set: #{set.inspect}"},
        :integer                  => lambda {"is not a number"},
        :length_range             => lambda {"is too short or too long"},
        :less_than                => lambda {|boundary| "must be less than #{boundary}"},
        :less_than_or_equal_to    => lambda {|boundary| "must be less than or equal to #{boundary}"},
        :max_length               => lambda {|max| "is longer than #{max} characters"},
        :min_length               => lambda {|min| "is shorter than #{min} characters"},
        :not_null                 => lambda {"is not present"},
        :numeric                  => lambda {"is not a number"},
        :presence                 => lambda {"is not present"}
      } 

      def initialize
        @messages = {}
      end

      def get(type, *args)
        args.compact.length > 0 ? message(type).call(*args) : message(type).call
      end

      def set(type, proc)
        @messages[type] = proc
      end

      private

      def message(type)
        @messages[type] || DEFAULT_MESSAGES[type] || DEFAULT_MESSAGES[:default]
      end
    end

    attr_reader :message

    def initialize
      @message = Message.new
    end
  end
end