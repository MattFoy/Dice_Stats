require 'bigdecimal'

module Dice_stats
	class Dice
		@count
		attr_accessor :count

		@sides
		attr_accessor :sides

		@probability_distribution

		def initialize(dice_count, dice_sides)
			@count = dice_count
			@sides = dice_sides
			@probability_distribution = {}

			if (@count < 0 || @sides < 0)
				#error
			else
				calculate_probability_distribution
			end
		end

		def max
			@count*@sides
		end

		def min
			@count
		end

		def expected
			BigDecimal(@count) * ((@sides + 1.0) / 2.0)
		end

		def variance
			var = BigDecimal.new(0)
			(1..@sides).each { |i|
				e = BigDecimal.new(@sides+1) / BigDecimal.new(2)
				var += (BigDecimal.new(i - e)**2) / BigDecimal.new(@sides)
			}
			var * BigDecimal.new(@count)
		end

		def standard_deviation
			BigDecimal.new(variance).sqrt(5)
		end

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

		def roll
			sum = 0
			@count.times do |i|
				sum += (1 + rand(@sides))
			end
			return sum
		end

		def calculate_probability_distribution
			number_of_possible_combinations = (@sides**@count)
			puts "Number of possible combinations: #{number_of_possible_combinations}"

			# weep softly: http://mathworld.wolfram.com/Dice.html
			(min..max).each { |p|
				if p > (max + min) / 2
					@probability_distribution[p] = @probability_distribution[max - p + min]
				else
					thing = (BigDecimal.new(p - @count) / BigDecimal.new(@sides)).floor

					c = BigDecimal.new(0)
					((0..thing).each { |k|
						n1 = ((-1)**k) 
						n2 = BigDecimal.new(Math_Utilities.Choose(@count, k))
						n3 = BigDecimal.new(Math_Utilities.Choose(p - (@sides * k) - 1, @count - 1))						
						t = BigDecimal.new(n1 * n2 * n3)

						c += t
					})

					#result = result.abs

					@probability_distribution[p] = BigDecimal.new(c) / BigDecimal.new(number_of_possible_combinations)
				end

				puts "\tProbability of #{p}: #{@probability_distribution[p].add(0, 5).to_s('F')}" 
			}

			puts "Sum of probability_distribution: " + (@probability_distribution.inject(BigDecimal.new(0)) {|total, (k,v)| BigDecimal.new(total + v) }).add(0, 5).to_s('F')
		end
	end
end