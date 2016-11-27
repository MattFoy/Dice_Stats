require 'dice_stats'

RSpec.describe Dice_Stats::Dice_Set do
	it 'can be used to roll dice' do
		d = Dice_Stats::Dice_Set.new("2d6")
		100.times do
			res = d.roll
			expect(res) .to be >= 2 
			expect(res) .to be <= 12
		end
	end

	it 'cleans up the pattern string for consistency' do
		d = Dice_Stats::Dice_Set.new("2d6 +3d8 +2d4+ 5")
		expect(d.clean_string) .to eq("3d8 + 2d6 + 2d4 + 5")
	end

	it 'can return stats about the dice' do
		d = Dice_Stats::Dice_Set.new("2d6 + 3d8 + 2d4 + 5")
		expect(d.min) .to eq(12)
		expect(d.max) .to eq(49)
		expect(d.expected) .to eq(30.5)
		expect(d.variance - 24.08) .to be < 0.01
		expect(d.standard_deviation - 4.9) .to be < 0.01
	end

	it 'has a probability distribution with sum(p) = 1' do
		d = Dice_Stats::Dice_Set.new("2d6 + 3d8 + 2d4 + 5")
		expect(1.0 - (d.probability_distribution.inject(0.0) { |m,(v,p)| m + p })) .to be < 0.001
	end

	it 'is as likely to roll a number above average as it is to roll below average' do
		d = Dice_Stats::Dice_Set.new("2d6 + 3d8 + 2d4 + 5")
		p_high = d.p.gt(d.expected).get
		p_low = d.p.lt(d.expected).get

		expect(p_high.round(5).to_f) .to eq(0.5)
		expect(p_low.round(5).to_f) .to eq(0.5)
	end

	it 'respects constants when querying probabilities' do
		d = Dice_Stats::Dice_Set.new("2d4 + 5")

		p_6 = d.p.eq(6).get
		# Lowest possible roll should be a 7, so p(6) == 0
		expect(p_6.round(5).to_f) .to eq(0.0)
	end
end