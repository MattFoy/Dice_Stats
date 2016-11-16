module Dice_Stats

end

module Dice_Stats::Internal_Utilities

	##
	# This class is used as a way to build clauses into a query of a probability distribution
	# The +probability_distribution+ start out complete and each query removes selections of it.

	class Filtered_distribution
		##
		# For internal use only. The Dice_Set#p method instantiates this with a fresh distribution for use in the query.
		def initialize(probability_distribution)
			@pd = probability_distribution
		end

		##
		# Use Filtered_distribution#get to return the sum of the remaining probabilities in the distribution
		def get
			@pd.inject(BigDecimal.new(0)) { |m, (k,v)| m + v }
		end

		##
		# The "less than" operator.
		def lt(val)
			@pd.select! { |k,v| k < val }
			return self
		end

		## 
		# The "less than or equal to" operator.
		def lte(val)
			@pd.select! { |k,v| k <= val }
			return self
		end

		##
		# The "greater than" operator.
		def gt(val)
			@pd.select! { |k,v| k > val }
			return self
		end

		##
		# The "greater than or equal to" operator.
		def gte(val)
			@pd.select! { |k,v| k >= val }
			return self
		end

		## 
		# The "equal to" operator. 
		# *Note:* This removes all options except the one specified. This is not useful in conjunction with any other operators.
		# The result of "p.eq(x).eq(y).get" will always be 0 if x and y are different.
		def eq(val)
			@pd.select! { |k,v| k == val }
			return self
		end

		##
		# The "not equal to" operator.
		# This allows for arbitrailty selecting out option that don't fit a ranged criteria.
		# For example "p.ne(2).ne(4).ne(6).get" would give the odds of rolling an odd number on a d6.
		def ne(val)
			@pd.select! { |k,v| k != val }
			return self
		end
	end
end