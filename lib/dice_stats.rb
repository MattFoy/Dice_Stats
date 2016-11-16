#The "main" function

##
# Dice_Stats is the main namespace for the gem.
# Dice Stats is a ruby gem for handling dice related statistics.
# see the README.md for more information.
module Dice_Stats
end

##
# The Internal_Utilities module is a namespace for some basic helper functions and classes used by Dice_Stats.
# Things in it are simply encapsulated this way to avoid polluting the lexical scope of the main module.
module Dice_Stats::Internal_Utilities
end

require 'Dice_Set'

##
# Instantiates the cache.
# The cache is an instance of a DB_cache_connection in the Internal_Utilities module.
# It is used to cache past results.
Dice_Stats::Cache = Dice_Stats::Internal_Utilities::DB_cache_connection.new