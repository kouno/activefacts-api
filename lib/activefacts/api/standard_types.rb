#
#       ActiveFacts Runtime API
#       Standard types extensions.
#
# Copyright (c) 2009 Clifford Heath. Read the LICENSE file.
#
# These extensions add ActiveFacts ObjectType and Instance behaviour into base Ruby value classes,
# and allow any Class to become an Entity.
#
require 'date'
require 'activefacts/api/numeric'

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
# Add the methods that convert our classes into ObjectType types:

ValueClasses = [String, Date, DateTime, Time, Int, Real, AutoCounter, Decimal]
ValueClasses.each{|c|
    c.send :extend, ActiveFacts::API::ValueClass
    c.send :include, ActiveFacts::API::ValueClassMethods
  }

class TrueClass #:nodoc:
  def verbalise(role_name = nil); role_name ? "#{role_name}: true" : "true"; end
  def identifying_role_values; self; end
  def self.identifying_role_values(*a); true; end
end

class FalseClass #:nodoc:
  def verbalise(role_name = nil); role_name ? "#{role_name}: false" : "false"; end
  def identifying_role_values; self; end
  def self.identifying_role_values(*a); false; end
end

class NilClass #:nodoc:
  def verbalise; "nil"; end
  def identifying_role_values; self; end
  def self.identifying_role_values(*a); nil; end
end

class Class
  # Make this Class into a ObjectType and if necessary its module into a Vocabulary.
  # The parameters are the names (Symbols) of the identifying roles.
  def identified_by *args, &b
    raise "#{basename} is not an entity type" if respond_to? :value_type  # Don't make a ValueType into an EntityType
    include ActiveFacts::API::Entity
    identified_by(*args, &b)
  end

  def is_entity_type
    respond_to?(:identifying_role_names)
  end
end

# These types are generated on conversion from NORMA's types:
class Char < String #:nodoc:  # FixedLengthText
end
class Text < String #:nodoc:  # LargeLengthText
end
class Image < String #:nodoc: # PictureRawData
end
class SignedInteger < Int #:nodoc:
end
class UnsignedInteger < Int   #:nodoc:
end
class AutoTimeStamp < String  #:nodoc: AutoTimeStamp
end
class Blob < String           #:nodoc: VariableLengthRawData
end
unless Object.const_defined?("Money")
  class Money < Decimal       #:nodoc:
  end
end
