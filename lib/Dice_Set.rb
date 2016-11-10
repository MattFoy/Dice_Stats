require 'Dice'
require 'Math_Utilities'

module Dice_stats
	class Dice_Set
		@dice
		@constant
		@input_string

		attr_accessor :dice

		def initialize(dice_string)
			@dice = []
			@constant = 0
			@input_string = dice_string

			split_string = dice_string.split('+')		

			split_string.map!{|i| i.strip }

			split_string.count.times { |i|
				if /\d+[dD]\d+/.match(split_string[i])
					sub_string_split = split_string[i].downcase.split('d')
					@dice << Dice.new(sub_string_split[0].to_i, sub_string_split[1].to_i)
				elsif (split_string[i].to_i > 0)
					constant += split_string[i].to_i
				else
					puts "Unexpected paramter: #{split_string[0]}"
				end
			}

			@dice.sort! { |d1,d2| d2.sides <=> d1.sides }
		end

		def clean_string
			formatted_string = ""
			@dice.each { |d| 
				formatted_string += d.count.to_s + "d" + d.sides.to_s + " + "
			}
			if @constant > 0
				formatted_string + @constant.to_s
			else
				formatted_string[0..formatted_string.length-4]
			end
		end

	end
end