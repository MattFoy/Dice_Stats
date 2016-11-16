module Dice_Stats::Internal_Utilities
	class Arbitrary_base_counter
		attr_reader :overflow

		def initialize(maximums)
			@overflow = false
			@index = maximums.map { |i| {:val => 0, :max => i} }
		end

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

		def length
			@index.length
		end

		def [](i)
			@index[i][:val]
		end

		def print
			puts @index
		end
	end
end