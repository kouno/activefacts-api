#
#       ActiveFacts Runtime API
#       Entity class (a mixin module for the class Class)
#
# Copyright (c) 2009 Clifford Heath. Read the LICENSE file.
#

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