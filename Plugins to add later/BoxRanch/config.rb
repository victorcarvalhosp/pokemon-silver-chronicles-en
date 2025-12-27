#===============================================================================
# * Box Ranch System - Configuration
#===============================================================================

module BoxRanchConfig
  # Ranch Map ID - Change this to your ranch map's ID
  MAP_ID = 889
  
  # Event naming for compatibility with other plugins
  # Set to true to add "Reflection" to event names for reflection compatibility
  USE_REFLECTION_NAMES = false
  
  # Custom event name prefixes (useful for plugin compatibility)
  # These are the default names that will be used for ranch pokemon events
  LAND_EVENT_PREFIX = "Pokemon"          # Default: "Pokemon_SPECIES"
  WATER_EVENT_PREFIX = "InWater_Pokemon" # Default: "InWater_Pokemon_SPECIES"
  
  # If USE_REFLECTION_NAMES is true, these will be used instead:
  # Useful for reflection plugins that look for "Reflection" in event names
  LAND_EVENT_PREFIX_REFLECTION = "Reflection_Pokemon"
  WATER_EVENT_PREFIX_REFLECTION = "Reflection_InWater_Pokemon"
  
  # Maximum Pokemon to display
  MAX_LAND_POKEMON = 8
  MAX_WATER_POKEMON = 5
  
  # Test Pokemon (shown when no Pokemon in boxes)
  CREATE_TEST_POKEMON = true
  TEST_LAND_SPECIES = :PIKACHU
  TEST_WATER_SPECIES = :MAGIKARP
  TEST_LEVEL = 5
  
  # Movement Speed Settings
  # Note: Following Pokemon typically use speed 4 (player's speed)
  # Movement speeds: 1=8x slower, 2=4x slower, 3=2x slower, 4=normal, 5=2x faster, 6=4x faster
  
  # Land Pokemon movement speed range
  LAND_SPEED_MIN = 2      # Minimum speed for land pokemon (4x slower than normal)
  LAND_SPEED_MAX = 4      # Maximum speed for land pokemon (normal speed)
  
  # Water Pokemon movement speed range (typically slower in water)
  WATER_SPEED_MIN = 2     # Minimum speed for water pokemon (4x slower than normal) 
  WATER_SPEED_MAX = 3     # Maximum speed for water pokemon (2x slower than normal)
  
  # Movement frequency range (how often they change direction)
  FREQUENCY_MIN = 2       # Minimum frequency (less frequent direction changes)
  FREQUENCY_MAX = 4       # Maximum frequency (more frequent direction changes)
end

#===============================================================================
# How to use this configuration:
#===============================================================================
# 
# 1. MAP_ID: Set this to your ranch map's ID number
# 
# 2. For Reflection Plugin compatibility:
#    - Set USE_REFLECTION_NAMES = true
#    - This will make event names like "Reflection_Pokemon_PIKACHU"
# 
# 3. For custom event naming:
#    - Modify LAND_EVENT_PREFIX and WATER_EVENT_PREFIX
#    - Event names will be: "#{PREFIX}_#{SPECIES}"
# 
# 4. Pokemon limits:
#    - MAX_LAND_POKEMON: How many land pokemon to show
#    - MAX_WATER_POKEMON: How many water pokemon to show
# 
# 5. Movement Speed (to match Following Pokemon speed of 4):
#    - LAND_SPEED_MIN/MAX: Range 2-4 = slower to normal speed
#    - WATER_SPEED_MIN/MAX: Range 2-3 = slower speeds for water
#    - FREQUENCY_MIN/MAX: How often they change direction
# 
# 6. Test Pokemon:
#    - Set CREATE_TEST_POKEMON = false to disable test pokemon
#    - Change TEST_LAND_SPECIES and TEST_WATER_SPECIES for different test pokemon
#===============================================================================
