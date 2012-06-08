module ActiveFacts
  module API
    # Adapter module to add value_type to all potential value classes
    module ValueClass #:nodoc:
      def value_type *args, &block #:nodoc:
        include ActiveFacts::API::Value
        value_type(*args, &block)
      end
    end

    module ValueClassMethods
      # Returns the value associated to a ValueClass object.
      #
      # For example, Real is a subclass of SimpleDelegator and
      # therefore uses Float as its delegate. The value of a
      # Real is then a Float.
      #
      # The primary reason for using this is when we are using
      # ValueClass objects as Hash keys, since the support on
      # various platform is still problematic.
      #
      #   r = Real.new(0.1)
      #   a = { 0.1 => 'v' }
      #   a[r.to_value]
      #   # returns 'v' whatever ruby platform you're using.
      def to_value
        case self
        when String
          to_s
        when Int, Decimal, Real
          __getobj__
        when AutoCounter, Date, DateTime, Time, String
          self
        else
          self
        end
      end
    end
  end
end