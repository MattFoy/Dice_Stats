cd ~/www/custom_gems/dice_stats
gem build dice_stats.gemspec
gem install -l dice_stats-0.0.3.gem
irb -r dice_stats --simple-prompt
ds1 = Dice_Stats::Dice_Set.new("2d8 + 3")
ds2 = Dice_Stats::Dice_Set.new("1d8 + 2d6")
#Dice_Stats::Math_Utilities.Cartesian_Product_For_Probabilities(ds1.dice.map { |d| d.probability_distribution })
#ds1.print_probability
#ds1.clean_string
