#
# DO NOT MODIFY!!!!
# This file is automatically generated by racc 1.4.5
# from racc grammer file "json_parser.y".
#

require 'racc/parser'



module RGen

module Instantiator


class JsonParser < Racc::Parser

module_eval <<'..end json_parser.y modeval..id3d5fb611e2', 'json_parser.y', 38

	ParserToken = Struct.new(:line, :file, :value)

  def initialize(instantiator)
    @instantiator = instantiator
  end
     	
	def parse(str, file=nil)
		@q = []
		line = 1
		
		until str.empty?
			case str
				when /\A\n/
					str = $'
					line +=1
				when /\A\s+/
					str = $'
				when /\A([-+]?\d+\.\d+)/
					str = $'
					@q << [:FLOAT, ParserToken.new(line, file, $1)]
				when /\A([-+]?\d+)/
					str = $'
					@q << [:INTEGER, ParserToken.new(line, file, $1)]
				when /\A"((?:[^"\\]|\\"|\\\\|\\[^"\\])*)"/
					str = $'
          sval = $1
          sval.gsub!('\\\\','\\')
          sval.gsub!('\\"','"')
          sval.gsub!('\\n',"\n")
          sval.gsub!('\\r',"\r")
          sval.gsub!('\\t',"\t")
          sval.gsub!('\\f',"\f")
          sval.gsub!('\\b',"\b")
					@q << [:STRING, ParserToken.new(line, file, sval)]
				when /\A(\{|\}|\[|\]|,|:|true|false)/
					str = $'
					@q << [$1, ParserToken.new(line, file, $1)]
        else
          raise "parse error in line #{line} on "+str[0..20].inspect+"..."
			end
		end
		@q.push [false, ParserToken.new(line, file, '$end')]
		do_parse
	end
	
	def next_token
		r = @q.shift
    r
	end
	
..end json_parser.y modeval..id3d5fb611e2

##### racc 1.4.5 generates ###

racc_reduce_table = [
 0, 0, :racc_error,
 1, 14, :_reduce_1,
 3, 16, :_reduce_2,
 2, 16, :_reduce_3,
 1, 17, :_reduce_4,
 3, 17, :_reduce_5,
 3, 18, :_reduce_6,
 2, 18, :_reduce_7,
 1, 19, :_reduce_8,
 3, 19, :_reduce_9,
 3, 20, :_reduce_10,
 1, 15, :_reduce_11,
 1, 15, :_reduce_12,
 1, 15, :_reduce_13,
 1, 15, :_reduce_14,
 1, 15, :_reduce_15,
 1, 15, :_reduce_16,
 1, 15, :_reduce_17 ]

racc_reduce_n = 18

racc_shift_n = 29

racc_action_table = [
     3,    16,    17,     7,    22,     8,    21,    10,    11,     1,
     2,     3,    12,    23,     7,    24,     8,    25,    10,    11,
     1,     2,     3,    20,    15,     7,    17,     8,   nil,    10,
    11,     1,     2,     3,   nil,   nil,     7,   nil,     8,   nil,
    10,    11,     1,     2 ]

racc_action_check = [
     0,     7,     7,     0,    15,     0,    14,     0,     0,     0,
     0,     3,     3,    17,     3,    18,     3,    19,     3,     3,
     3,     3,    20,    13,     4,    20,    25,    20,   nil,    20,
    20,    20,    20,    23,   nil,   nil,    23,   nil,    23,   nil,
    23,    23,    23,    23 ]

racc_action_pointer = [
    -2,   nil,   nil,     9,    24,   nil,   nil,    -5,   nil,   nil,
   nil,   nil,   nil,    19,     3,     4,   nil,     5,     9,    13,
    20,   nil,   nil,    31,   nil,    19,   nil,   nil,   nil ]

racc_action_default = [
   -18,   -16,   -17,   -18,   -18,    -1,   -11,   -18,   -13,   -12,
   -14,   -15,    -3,    -4,   -18,   -18,    -7,   -18,   -18,    -8,
   -18,    -2,    29,   -18,    -6,   -18,    -5,   -10,    -9 ]

racc_goto_table = [
     5,    18,     4,    14,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,    28,
    26,   nil,   nil,    27 ]

racc_goto_check = [
     2,     6,     1,     4,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,     6,
     4,   nil,   nil,     2 ]

racc_goto_pointer = [
   nil,     2,     0,   nil,     0,   nil,    -6,   nil ]

racc_goto_default = [
   nil,   nil,    13,     6,   nil,     9,   nil,    19 ]

racc_token_table = {
 false => 0,
 Object.new => 1,
 "[" => 2,
 "]" => 3,
 "," => 4,
 "{" => 5,
 "}" => 6,
 :STRING => 7,
 ":" => 8,
 :INTEGER => 9,
 :FLOAT => 10,
 "true" => 11,
 "false" => 12 }

racc_use_result_var = true

racc_nt_base = 13

Racc_arg = [
 racc_action_table,
 racc_action_check,
 racc_action_default,
 racc_action_pointer,
 racc_goto_table,
 racc_goto_check,
 racc_goto_default,
 racc_goto_pointer,
 racc_nt_base,
 racc_reduce_table,
 racc_token_table,
 racc_shift_n,
 racc_reduce_n,
 racc_use_result_var ]

Racc_token_to_s_table = [
'$end',
'error',
'"["',
'"]"',
'","',
'"{"',
'"}"',
'STRING',
'":"',
'INTEGER',
'FLOAT',
'"true"',
'"false"',
'$start',
'json',
'value',
'array',
'valueList',
'object',
'memberList',
'member']

Racc_debug_parser = false

##### racc system variables end #####

 # reduce 0 omitted

module_eval <<'.,.,', 'json_parser.y', 4
  def _reduce_1( val, _values, result )
 result = val[0]
   result
  end
.,.,

module_eval <<'.,.,', 'json_parser.y', 6
  def _reduce_2( val, _values, result )
 result = val[1]
   result
  end
.,.,

module_eval <<'.,.,', 'json_parser.y', 7
  def _reduce_3( val, _values, result )
 result = []
   result
  end
.,.,

module_eval <<'.,.,', 'json_parser.y', 9
  def _reduce_4( val, _values, result )
 result = [ val[0] ]
   result
  end
.,.,

module_eval <<'.,.,', 'json_parser.y', 10
  def _reduce_5( val, _values, result )
 result = [ val[0] ] + val[2]
   result
  end
.,.,

module_eval <<'.,.,', 'json_parser.y', 12
  def _reduce_6( val, _values, result )
 result = @instantiator.createObject(val[1])
   result
  end
.,.,

module_eval <<'.,.,', 'json_parser.y', 13
  def _reduce_7( val, _values, result )
 result = nil
   result
  end
.,.,

module_eval <<'.,.,', 'json_parser.y', 15
  def _reduce_8( val, _values, result )
 result = val[0]
   result
  end
.,.,

module_eval <<'.,.,', 'json_parser.y', 16
  def _reduce_9( val, _values, result )
 result = val[0].merge(val[2])
   result
  end
.,.,

module_eval <<'.,.,', 'json_parser.y', 18
  def _reduce_10( val, _values, result )
 result = {val[0].value => val[2]}
   result
  end
.,.,

module_eval <<'.,.,', 'json_parser.y', 20
  def _reduce_11( val, _values, result )
 result = val[0]
   result
  end
.,.,

module_eval <<'.,.,', 'json_parser.y', 21
  def _reduce_12( val, _values, result )
 result = val[0]
   result
  end
.,.,

module_eval <<'.,.,', 'json_parser.y', 22
  def _reduce_13( val, _values, result )
 result = val[0].value
   result
  end
.,.,

module_eval <<'.,.,', 'json_parser.y', 23
  def _reduce_14( val, _values, result )
 result = val[0].value.to_i
   result
  end
.,.,

module_eval <<'.,.,', 'json_parser.y', 24
  def _reduce_15( val, _values, result )
 result = val[0].value.to_f
   result
  end
.,.,

module_eval <<'.,.,', 'json_parser.y', 25
  def _reduce_16( val, _values, result )
 result = true
   result
  end
.,.,

module_eval <<'.,.,', 'json_parser.y', 26
  def _reduce_17( val, _values, result )
 result = false
   result
  end
.,.,

 def _reduce_none( val, _values, result )
  result
 end

end   # class JsonParser


end

end

