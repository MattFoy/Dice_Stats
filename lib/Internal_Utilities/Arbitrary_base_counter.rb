module Dice_Stats

end

module Dice_Stats::Internal_Utilities

	##
	# This class defines a counter where each "digit" has a different base.
	# For example, a counter of two digits, the first with base 3 and the second with base 2 may go like this:
	# 0 => [0, 0]
	# 1 => [0, 1]
	# 2 => [1, 0]
	# 3 => [1, 1]
	# 4 => [2, 0]
	# 5 => [2, 1]
	# 5 would be the maximum number the counter could hold.
	# 
	# TODO:
	# * Add a "decrement" method
	# * Add a "value" method to return the count in base 10

	class Arbitrary_base_counter
		##
		# A boolean value representing if the result has overflown.
		# Will be false initially, will be set to true if the counter ends up back at [0, 0, ..., 0]
		attr_reader :overflow

		##
		# Define a new counter.
		# +maximums+ is an array of integers, each specifying the base of its respective digit.
		# For example, to create a counter of 3 base 2 digits, supply [2,2,2]
		def initialize(maximums)
			@overflow = false
			@index = maximums.map { |i| {:val => 0, :max => i} }
		end

		##
		# Increase the "value" of the counter by one
		def increment
			#start at the end of the array (i.e. the "lowest" significant digit)
			i = @index.length - 1 

			loop do
				#increment the last value
				@index[i][:val] += 1

				#check if it has "overflown" that digits base
				if @index[i][:val] >= @index[i][:max]
					#set it to 0
					@index[i][:val] = 0
					
					if (i == 0) 
						@overflow = true
					end

					#move to the next digit to the "left"
					i -= 1
					
				else
					#done
					break
				end
			end
		end

		##
		# Return an integer representing how many digits the counter holds
		def length
			@index.length
		end


		##
		# Overloaded index operator, used to retrieve the number stored in the +i+th digit place
		def [](i)
			@index[i][:val]
		end

		##
		# Puts the array of digits.
		def print
			puts @index
		end
	end
end