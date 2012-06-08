#
#       ActiveFacts Runtime API.
#       Various additions or patches to Ruby built-in classes, and some global support methods
#
# Copyright (c) 2009 Clifford Heath. Read the LICENSE file.
#

# Define Infinity as a constant, if it's not already defined:
# We use this to define open-ended ranges.
begin
  Object.const_get("Infinity")
rescue
  Infinity = 1.0/0.0
end

class Symbol #:nodoc:
  def to_proc
    Proc.new{|*args| args.shift.__send__(self, *args)}
  end
end

class String #:nodoc:
  # This may be overridden by a version from ActiveSupport. For our purposes, either will work.
  def camelcase(first_letter = :upper)
    if first_letter == :upper
      gsub(/(^|[_\s]+)([A-Za-z])/){ $2.upcase }
    else
      gsub(/([_\s]+)([A-Za-z])/){ $2.upcase }
    end
  end

  def snakecase
    gsub(/([a-z])([A-Z])/,'\1_\2').downcase
  end

  def camelwords
    gsub(/-([a-zA-Z])/){ $1.upcase }.                 # Break and upcase on hyphenated words
      gsub(/([a-z])([A-Z])/,'\1_\2').
      split(/[_\s]+/)
  end
end

class Module #:nodoc:
  def modspace
    space = name[ 0...(name.rindex( '::' ) || 0)]
    space == '' ? Object : eval(space)
  end

  def basename
    name.gsub(/.*::/, '')
  end
end

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

module ActiveFacts #:nodoc:
  # If the args array ends with a hash, remove it.
  # If the remaining args are fewer than the arg_names,
  # extract values from the hash and append them to args.
  # Return the new args array and the hash.
  # In any case leave the original args unmodified.
  def self.extract_hash_args(arg_names, args)
    if Hash === args[-1]
      arg_hash = args[-1]     # Don't pop args, leave it unmodified
      args = args[0..-2]
      arg_hash = arg_hash.clone if (args.size < arg_names.size)
      while args.size < arg_names.size
        args << arg_hash[n = arg_names[args.size]]
        arg_hash.delete(n)
      end
    else
      arg_hash = {}
    end
    return args, arg_hash
  end
end