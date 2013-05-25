require 'base64'

hex_string = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"

base64_string = Base64.encode64(hex_string)
puts base64_string
string = Base64.decode64(base64_string)
puts string
