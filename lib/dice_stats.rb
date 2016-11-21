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