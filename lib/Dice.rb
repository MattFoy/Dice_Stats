require 'bigdecimal'
require 'Internal_Utilities/Math_Utilities'

module Dice_Stats

	##
	# This class repsents the roll statistics for a single type of dice. i.e. all d6s, or all d8s.
	# The probability distribution is generated via the generating function found on line (10) of http://mathworld.wolfram.com/Dice.html
	class Dice

		##
		# The number of dice, and how many sides they have.
		attr_accessor :count, :sides

		##
		# The probability distribution of the dice.
		attr_reader :probability_distribution

		##
		# Creates a new Dice instance of a number of dice (+dice_count+) with +dice_sides+ faces.
		# All dice are assumed to go from 1 to +dice_sides+.
		def initialize(dice_count, dice_sides)
			@count = dice_count
			@sides = dice_sides
			@probability_distribution = {}

			if (@count < 0 || @sides < 0)
				#error
			else
				@probability_distribution = calculate_probability_distribution
			end
		end

		##
		# Returns the highest possible roll
		def max
			@count*@sides
		end

		## 
		# Returns the lowest possible roll
		def min
			@count
		end

		## 
		# Returns the average roll result
		def expected
			BigDecimal(@count) * ((@sides + 1.0) / 2.0)
		end

		##
		# Returns the variance of the roll
		def variance
			var = BigDecimal.new(0)
			(1..@sides).each { |i|
				e = BigDecimal.new(@sides+1) / BigDecimal.new(2)
				var += (BigDecimal.new(i - e)**2) / BigDecimal.new(@sides)
			}
			var * BigDecimal.new(@count)
		end

		##
		# Returns the standard deviation of the roll
		def standard_deviation
			BigDecimal.new(variance).sqrt(5)
		end

		##
		# Prints some basic stats about this roll
		def print_stats
			puts "Min: #{min}"
			puts "Max: #{max}"
			puts "Expected: #{expected}"
			puts "Std Dev: #{standard_deviation}"
			puts "Variance: #{variance}"

			@probability_distribution.each { |k,v| 
				puts "P(#{k}) => #{v}"
			}
		end

		##
		# Rolls the dice and returns the result
		def roll
			sum = 0
			@count.times do |i|
				sum += (1 + rand(@sides))
			end
			return sum
		end

		##
		# For internal use only.
		# Caclulates the probability distribution on initialization
		def calculate_probability_distribution
			number_of_possible_combinations = (@sides**@count)
			#puts "Number of possible combinations: #{number_of_possible_combinations}"
			result = {}
			# weep softly: http://mathworld.wolfram.com/Dice.html
			(min..max).each { |p|
				if p > (max + min) / 2
					result[p] = result[max - p + min]
				else
					thing = (BigDecimal.new(p - @count) / BigDecimal.new(@sides)).floor

					c = BigDecimal.new(0)
					((0..thing).each { |k|
						n1 = ((-1)**k) 
						n2 = BigDecimal.new(Internal_Utilities::Math_Utilities.Choose(@count, k))
						n3 = BigDecimal.new(Internal_Utilities::Math_Utilities.Choose(p - (@sides * k) - 1, @count - 1))						
						t = BigDecimal.new(n1 * n2 * n3)

						c += t
					})

					#result = result.abs

					result[p] = BigDecimal.new(c) / BigDecimal.new(number_of_possible_combinations)
				end

				#puts "\tProbability of #{p}: #{@probability_distribution[p].add(0, 5).to_s('F')}" 
			}
			@probability_distribution = result
			#puts "Sum of probability_distribution: " + (@probability_distribution.inject(BigDecimal.new(0)) {|total, (k,v)| BigDecimal.new(total + v) }).add(0, 5).to_s('F')
		end

		##
		# Returns the probability of a specific result (+val+). *Not* to be confused with Dice_Set#p.
		def p(val)
			if (@probability_distribution.key?(val))
				return @probability_distribution[val]
			else
				return 0
			end
		end
	end
end