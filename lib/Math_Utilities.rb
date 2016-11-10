module Dice_stats
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

		def self.Cartesian_Product(collection_1, collection_2)
			#collection_1 and _2 must be arrays of objects

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