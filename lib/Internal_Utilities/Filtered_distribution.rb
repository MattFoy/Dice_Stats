module Dice_Stats

end

module Dice_Stats::Internal_Utilities
	class Filtered_distribution
		def initialize(probability_distribution)
			@pd = probability_distribution
		end

		def get
			@pd.inject(BigDecimal.new(0)) { |m, (k,v)| m + v }
		end


		def lt(val)
			@pd.select! { |k,v| k < val }
			return self
		end

		def lte(val)
			@pd.select! { |k,v| k <= val }
			return self
		end

		def gt(val)
			@pd.select! { |k,v| k > val }
			return self
		end

		def gte(val)
			@pd.select! { |k,v| k >= val }
			return self
		end

		def eq(val)
			@pd.select! { |k,v| k == val }
			return self
		end

		def ne(val)
			@pd.select! { |k,v| k != val }
			return self
		end
	end
end