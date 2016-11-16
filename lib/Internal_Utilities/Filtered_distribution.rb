module Dice_Stats::Internal_Utilities
	class Filtered_distribution
		def initialize(probability_distribution)
			@probability_distribution = probability_distribution
		end

		def get
			@probability_distribution.inject(BigDecimal.new(0)) { |m, (k,v)| m + v }
		end


		def lt(val)
			@probability_distribution.select! { |k,v| k < val }
			return self
		end

		def lte(val)
			lt(val+1)
		end

		def gt(val)
			@probability_distribution.select! { |k,v| k > val }			
			return self
		end

		def gte(val)
			lt(val-1)
		end

		def eq(val)
			@probability_distribution.select! { |k,v| k == val }
			return self
		end

		def ne(val)
			@probability_distribution.select! { |k,v| k != val }
			return self
		end
	end
end