require 'dice_stats'

RSpec.describe Dice_Stats::Internal_Utilities::Arbitrary_base_counter do
	it 'is a counter that can be specified to have an arbitrary base for each digit place' do
		counter = Dice_Stats::Internal_Utilities::Arbitrary_base_counter.new([2, 2, 3])

		# The counter is initialized to zeroes
		expect(counter[0]) .to eq(0)
		expect(counter[1]) .to eq(0)
		expect(counter[2]) .to eq(0)

		# Increase the count
		counter.increment

		expect(counter[0]) .to eq(0)
		expect(counter[1]) .to eq(0)
		expect(counter[2]) .to eq(1)

		# Increase the count
		counter.increment

		expect(counter[0]) .to eq(0)
		expect(counter[1]) .to eq(0)
		expect(counter[2]) .to eq(2)

		# Increase the count
		counter.increment

		expect(counter[0]) .to eq(0)
		expect(counter[1]) .to eq(1)
		expect(counter[2]) .to eq(0)

		# Increase the count
		counter.increment

		expect(counter[0]) .to eq(0)
		expect(counter[1]) .to eq(1)
		expect(counter[2]) .to eq(1)

		# Increase the count
		counter.increment

		expect(counter[0]) .to eq(0)
		expect(counter[1]) .to eq(1)
		expect(counter[2]) .to eq(2)

		# Increase the count
		counter.increment

		expect(counter[0]) .to eq(1)
		expect(counter[1]) .to eq(0)
		expect(counter[2]) .to eq(0)

		# Increase the count
		counter.increment

		expect(counter[0]) .to eq(1)
		expect(counter[1]) .to eq(0)
		expect(counter[2]) .to eq(1)
	end

	it 'can overflow' do
		counter = Dice_Stats::Internal_Utilities::Arbitrary_base_counter.new([2, 2, 2])

		8.times { counter.increment }

		expect(counter.overflow) .to eq(true)
	end
end