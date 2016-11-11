require 'Dice'
require 'Math_Utilities'

module Dice_Stats
	class Dice_Set
		attr_reader :probability_distribution
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
					@constant += split_string[i].to_i
				else
					puts "Unexpected paramter: #{split_string[0]}"
				end
			}

			@dice.sort! { |d1,d2| d2.sides <=> d1.sides }

			@probability_distribution = combine_probability_distributions

			if (@probability_distribution.inject(0) { |memo,(k,v)| memo + v }.round(3).to_f != 1.0)
				puts "Error in probability distrubtion."
			end
			
		end

		def max
			@dice.inject(0) { |memo, d| memo + d.max }.to_i
		end

		def min
			@dice.inject(0) { |memo, d| memo + d.min }.to_i
		end

		def expected
			@dice.inject(0) { |memo, d| memo + d.expected }.to_f
		end

		def variance
			@probability_distribution.inject(0) { |memo, (key,val)| memo + ((key - expected)**2 * val) }.round(10).to_f
		end

		def standard_deviation
			BigDecimal.new(variance, 10).sqrt(5).round(10).to_f
		end

		def combine_probability_distributions
			separate_distributions = @dice.map { |d| d.probability_distribution }
			Math_Utilities.Cartesian_Product_For_Probabilities(separate_distributions)
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

		def print_probability
			@probability_distribution.each { |k,v| puts "p(#{k}) => #{v.round(8).to_f}"}
		end

	end
end