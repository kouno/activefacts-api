#
#       ActiveFacts Runtime API
#       Entity class (a mixin module for the class Class)
#
# Copyright (c) 2009 Clifford Heath. Read the LICENSE file.
#


module ActiveFacts
  module API
    # Fixes behavior of core functions over multiple platform
    module SimpleDelegation
      def initialize(v)
        __setobj__(delegate_new(v))
      end

      def eql?(v)
        # Note: This and #hash do not work the way you'd expect,
        # and differently in each Ruby interpreter. If you store
        # an Int or Real in a hash, you cannot reliably retrieve
        # them with the corresponding Integer or Real.
        __getobj__.eql?(delegate_new(v))
      end

      def ==(o)                             #:nodoc:
        __getobj__.==(o)
      end

      def to_s                              #:nodoc:
        __getobj__.to_s
      end

      def to_json                           #:nodoc:
        __getobj__.to_s
      end

      def hash                              #:nodoc:
        __getobj__.hash
      end

      def is_a?(k)
        __getobj__.is_a?(k) || super
      end

      def kind_of?(k)
        is_a?(k)
      end

      def inspect
        "#{self.class.basename}:#{__getobj__.inspect}"
      end
    end
  end
end
