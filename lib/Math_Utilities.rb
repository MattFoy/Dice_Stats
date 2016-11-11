require 'Arbitrary_base_counter'

module Dice_Stats
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

		def self.Cartesian_Product(arrays) #arrays is an array of array to cartesian product
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
			#puts
			#puts "Considering hashes: #{hashes}"
			#puts

			if (hashes.class != Array)
				puts "Not an array"
			elsif (hashes.length == 1)
				hashes[0]
			elsif (hashes.length == 0)
				Hash.new
			elsif (hashes[0].class != Hash)
				puts "Not a Hash of Hashes"
			else
				counter = Arbitrary_base_counter.new([*0..hashes.length-1].map { |i| hashes[i].length })
				hashes.map! { |h| h.to_a }
				set = 0

				while !counter.overflow do
					value = 0
					probability = 1					
					sub_result = {}

					#puts "Counter status: #{counter.print}"

					(0..counter.length-1).each { |i|
						value += hashes[i][counter[i]][0]
						probability *= hashes[i][counter[i]][1]
						#puts "\ti: #{i}, value: #{hashes[i][counter[i]][0]}, prob: #{hashes[i][counter[i]][1]}"
						#puts "Incremental result: {#{value} => #{probability}}"
					}
					set += 1
					#puts "\tDone set \##{set}."
					#puts "\tIncremental result: {#{value} => #{probability}}"
					if (result.key?(value))
						#puts "\tValue #{value} exists. Adding probability."
						result[value] += probability
					else
						#puts "\tSaving new result."
						result[value] = probability
					end

					counter.increment
					#puts "Incrementing counter."
					#puts
				end
				#puts "Done!"
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