require 'dice_stats'

RSpec.describe Dice_Stats::Internal_Utilities::Math_Utilities do
	it 'has a factorial function' do
		expect(Dice_Stats::Internal_Utilities::Math_Utilities.Factorial(0)) .to eq(0)
	end

	it 'has a factorial function' do
		expect(Dice_Stats::Internal_Utilities::Math_Utilities.Factorial(-2)) .to eq(0)
	end

	it 'has a factorial function' do
		expect(Dice_Stats::Internal_Utilities::Math_Utilities.Factorial(6)) .to eq(720)
	end

	it 'has a factorial function' do
		expect(Dice_Stats::Internal_Utilities::Math_Utilities.Factorial(5)) .to eq(120)
	end

	it 'has a factorial function' do
		expect(Dice_Stats::Internal_Utilities::Math_Utilities.Factorial(4)) .to eq(24)
	end

	it 'has a factorial function' do
		expect(Dice_Stats::Internal_Utilities::Math_Utilities.Factorial(3)) .to eq(6)
	end

	it 'has a factorial function' do
		expect(Dice_Stats::Internal_Utilities::Math_Utilities.Factorial(2)) .to eq(2)
	end

	it 'has a factorial function' do
		expect(Dice_Stats::Internal_Utilities::Math_Utilities.Factorial(1)) .to eq(1)
	end

	it 'has a Choose function' do
		expect(Dice_Stats::Internal_Utilities::Math_Utilities.Choose(6, 6)) .to eq(1)
	end

	it 'has a Choose function' do
		expect(Dice_Stats::Internal_Utilities::Math_Utilities.Choose(5, 0)) .to eq(1)
	end

	it 'has a Choose function' do
		expect(Dice_Stats::Internal_Utilities::Math_Utilities.Choose(-1, 5)) .to eq(1)
	end

	it 'has a Choose function' do
		expect(Dice_Stats::Internal_Utilities::Math_Utilities.Choose(5, -1)) .to eq(1)
	end

	it 'has a Choose function' do
		expect(Dice_Stats::Internal_Utilities::Math_Utilities.Choose(5, 3)) .to eq(10)
	end

	it 'has a Choose function' do
		expect(Dice_Stats::Internal_Utilities::Math_Utilities.Choose(6, 2)) .to eq(15)
	end

	it 'has a Choose function' do
		expect(Dice_Stats::Internal_Utilities::Math_Utilities.Choose(14, 7)) .to eq(3432)
	end

	it 'has a Choose function' do
		expect(Dice_Stats::Internal_Utilities::Math_Utilities.Choose(7, 2)) .to eq(21)
	end

	it 'has a Choose function' do
		expect(Dice_Stats::Internal_Utilities::Math_Utilities.Choose(7, 5)) .to eq(21)
	end

	it 'has a Choose function' do
		expect(Dice_Stats::Internal_Utilities::Math_Utilities.Choose(6, 3)) .to eq(20)
	end
end