require 'Dice'
require 'Internal_Utilities/Math_Utilities'
require 'Internal_Utilities/Filtered_distribution'

module Dice_Stats

	##
	# This class represents the roll statistics for a combination of dice.
	# The probability distribution is based off the constituent dice distributions.
	class Dice_Set
		##
		# The raw probability distribution of the dice set.
		# Can be queried more interactively through Dice_Set#p.
		attr_reader :probability_distribution

		##
		# The constituent separate dice
		attr_accessor :dice

		##
		# Instantiates a new Dice_Set with the specified +dice_string+ pattern.
		# Examples:
		# "2d6 + 1d3"
		# "2d6 + 5"
		# "1d8"
		# "5d4 + 3d10"
		def initialize(dice_string)
			@dice = []
			@constant = 0
			@input_string = dice_string
			@aborted_probability_distribution = false

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

			if @dice.inject(1) { |memo,d| memo * d.probability_distribution.length } > 10_000_000
				# if the n-ary cartesian product has to process more than 10,000,000 combinations it can take quite a while to finish...
				@aborted_probability_distribution = true
			else
				@dice.sort! { |d1,d2| d2.sides <=> d1.sides }

				@probability_distribution = combine_probability_distributions
				
				if (@probability_distribution.inject(0) { |memo,(k,v)| memo + v }.round(3).to_f != 1.0)
					#puts "Error in probability distrubtion."
				end
			end
		end

		##
		# Returns the highest possible roll
		def max
			@dice.inject(0) { |memo, d| memo + d.max }.to_i + @constant
		end

		##
		# Returns the lowest possible roll
		def min
			@dice.inject(0) { |memo, d| memo + d.min }.to_i + @constant
		end

		## 
		# Returns the average roll result
		def expected
			@dice.inject(0) { |memo, d| memo + d.expected }.to_f + @constant
		end

		##
		# Returns the variance of the roll
		def variance
			@probability_distribution.inject(0) { |memo, (key,val)| memo + ((key - (expected - @constant))**2 * val) }.round(10).to_f
		end

		##
		# Returns the standard deviation of the roll
		def standard_deviation
			BigDecimal.new(variance, 10).sqrt(5).round(10).to_f
		end

		## 
		# For internal use only.
		# Takes the cartesian product of the individual dice and combines them.
		def combine_probability_distributions
			separate_distributions = @dice.map { |d| d.probability_distribution }
			Internal_Utilities::Math_Utilities.Cartesian_Product_For_Probabilities(separate_distributions)
		end

		## 
		# Returns the dice string used to generate the pattern sorted by dice face, descending.
		# For example "2d3 + 2 + 1d6" would become "1d6 + 2d3 + 2"
		# If +with_constant+ is set to false, the constant "+ 2" will be ommitted.
		def clean_string(with_constant=true)
			formatted_string = ""
			@dice.each { |d| 
				formatted_string += d.count.to_s + "d" + d.sides.to_s + " + "
			}
			if with_constant && @constant > 0
				formatted_string + @constant.to_s
			else
				formatted_string[0..formatted_string.length-4]
			end
		end

		##
		# Displays the probability distribution. 
		# Can take up quite a lot of screen space for the mroe complicated rolls. 
		def print_probability
			@probability_distribution.each { |k,v| puts "p(#{k}) => #{v.round(8).to_f}"}
		end

		##
		# Simulates a roll of the dice
		def roll
			@dice.inject(@constant || 0) { |memo,d| memo + d.roll }
		end

		## 
		# Instantiates and returns a Filtered_distribution. See the documentation for Filtered_distribution.rb.
		def p
			weighted_prob_dist = @probability_distribution.inject(Hash.new) { |m,(k,v)| m[k+@constant] = v; m }
			filtered_distribution = Internal_Utilities::Filtered_distribution.new(weighted_prob_dist)
			return filtered_distribution
		end

		##
		# If the probability distribution was determined to be too complex to compute this will return true.
		def too_complex?
			@aborted_probability_distribution
		end
	end
end