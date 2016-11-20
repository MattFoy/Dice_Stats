Gem::Specification.new { |s|
  s.name        = 'dice_stats'
  s.version     = '0.1.0'
  s.date        = '2016-11-07'
  s.summary     = "Dice statistics utility."
  s.description = "Provides utilities for calculating dice statistics"
  s.authors     = ["Matthew Foy"]
  s.email       = 'mattfoy91@gmail.com'
  s.files       = ["lib/dice_stats.rb", "lib/Dice.rb", "lib/Dice_Set.rb", 
  "lib/Internal_Utilities/Math_Utilities.rb", "lib/Internal_Utilities/Arbitrary_base_counter.rb", 
  "lib/Internal_Utilities/Filtered_distribution.rb", "lib/Internal_Utilities/probability_cache_db.rb"]
  s.homepage    = 'http://matthewfoy.ca'
  s.license     = 'MIT'
}