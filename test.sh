#!/bin/bash
cd ~/www/custom_gems/dice_stats
gem build dice_stats.gemspec
gem install -l dice_stats-0.0.1.gem
irb -r dice_stats --simple-prompt
ds1 = Dice_Stats::Dice_Set.new("2d8 + 1d6 + 3d4 + 2d10 + 3d12")
#Dice_stats::Math_Utilities.Cartesian_Product_For_Probabilities(ds1.dice.map { |d| d.probability_distribution })
ds1.print_probability
