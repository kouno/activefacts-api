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
  end
end
# Add the methods that convert our classes into ObjectType types:

ValueClasses = [String, Date, DateTime, Time, Int, Real, AutoCounter, Decimal]
ValueClasses.each{|c|
    c.send :extend, ActiveFacts::API::ValueClass
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
