#!/bin/bash
cd ~/www/custom_gems/dice_stats
gem build dice_stats.gemspec
gem install dice_stats-0.0.1.gem
irb -r dice_stats --simple-prompt
ds1 = Dice_stats::Dice_Set.new("1d6")
ds1.dice[0].print_stats

