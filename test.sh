cd ~/www/custom_gems/dice_stats
gem build dice_stats.gemspec
gem uninstall -a dice_stats
gem install -l dice_stats-0.3.1.gem
irb -r dice_stats --simple-prompt
ds1 = Dice_Stats::Dice_Set.new("1d6")
