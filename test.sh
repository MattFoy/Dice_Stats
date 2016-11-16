cd ~/www/custom_gems/dice_stats
gem build dice_stats.gemspec
gem install -l dice_stats-0.0.4.gem
irb -r dice_stats --simple-prompt
ds1 = Dice_Stats::Dice_Set.new("1d6")
