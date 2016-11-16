require_relative 'Arbitrary_base_counter'

module Dice_Stats

end

module Dice_Stats::Internal_Utilities
	class Math_Utilities
		def self.Choose(a, b)
			if (a < 0 || b < 0 || (a < b))
				1
			elsif (a == b || b == 0)
				1
			else
				(a-b+1..a).inject(1, &:*) / (2..b).inject(1, &:*)
			end
		end

		def self.Factorial(a)
			(1..a).inject(:*) || 0
		end

		## Note that this method is not actually used. It was a proof of concept for templating a less "clever" way to do a
		## Cartesian product of arbitrary objects in such a way that additional processing can be done on the elements.
		def self.Cartesian_Product(arrays) #arrays is an array of array to cartesian product

			# FROM https://gist.github.com/sepastian/6904643
			# I found these examples later, after creating Option 3.
			# TODO: See if using these can be used to simplify the process.
			#Option 1
			arrays[0].product(*arrays[1..-1])
			#Option 2
			arrays[1..-1].inject(arrays[0]) { |m,v| m.product(v).map(&:flatten) }

			#Option 3
			# however, we need to actually perform additional logic on the specific combinations, 
			# not just aggregate them into one giant array
			result = []
			if (arrays.class != [].class)
				puts "Not an array"			
			elsif (arrays.length == 1)
				arrays[0]
			elsif (arrays.length == 0)
				puts "No input."
			elsif (arrays[0].class != [].class)
				puts "Not an array of arrays"
			else	
				counter = Arbitrary_base_counter.new([*0..arrays.length-1].map { |i| arrays[i].length })

				while !counter.overflow do
					sub_result = []
					(0..counter.length-1).each { |i|
						sub_result << arrays[i][counter[i]]
					}
					result << sub_result

					counter.increment
				end
			end

			result
		end

		def self.Cartesian_Product_For_Probabilities(hashes) #hashes is a hash of hashes to cartesian product
			result = {}

			if (hashes.class != Array)
				puts "Not an array"
			elsif (hashes.length == 1)
				puts "Returning first result"
				result = hashes.first
			elsif (hashes.length == 0)
				puts "Returning new hash"
				result = { 0 => 1 }
			elsif (hashes[0].class != Hash)
				puts "Not a Hash of Hashes"
			else
				counter = Arbitrary_base_counter.new([*0..hashes.length-1].map { |i| hashes[i].length })
				hashes.map! { |h| h.to_a }

				while !counter.overflow do
					value = 0
					probability = 1					
					sub_result = {}

					(0..counter.length-1).each { |i|
						value += hashes[i][counter[i]][0]
						probability *= hashes[i][counter[i]][1]
					}
					if (result.key?(value))
						result[value] += probability
					else
						result[value] = probability
					end

					counter.increment
				end
			end

			result
		end

		def self.Test_Suite
			#Choose
			puts "Testing Choose edge cases..."
			Test_Choose(6, 10, 1)
			Test_Choose(6, 6, 1)
			Test_Choose(5, 0, 1)
			Test_Choose(-1, 5, 1)
			Test_Choose(5, -1, 1)
			puts
			puts "Testing Choose basic math..."
			Test_Choose(5, 3, 10)
			Test_Choose(6, 2, 15)
			Test_Choose(14, 7, 3432)
			Test_Choose(7, 2, 21)
			Test_Choose(7, 5, 21)
			Test_Choose(7, 5, 21)
			Test_Choose(6, 3, 20)

			#Factorial
			puts
			puts "Testing Factorial edge cases..."
			Test_Factorial(0, 0)
			Test_Factorial(-2, 0)
			puts
			puts "Testing Factorial basic math..."
			Test_Factorial(6, 720)
			Test_Factorial(5, 120)
			Test_Factorial(4, 24)
			Test_Factorial(3, 6)
			Test_Factorial(2, 2)
		end

		def self.Test_Choose(a, b, expected)
			puts "(#{a} #{b}) => #{expected} (Actual: " + self.Choose(a, b).to_s + ")"
			if (self.Choose(a, b) != expected) 
				puts "`--> ERROR. FAILING CASE."
			end
		end

		def self.Test_Factorial(a, expected)
			puts "#{a}! => #{expected} (Actual: " + self.Factorial(a).to_s + ")"
			if (self.Factorial(a) != expected) 
				puts "`--> ERROR. FAILING CASE."
			end
		end
	end
end