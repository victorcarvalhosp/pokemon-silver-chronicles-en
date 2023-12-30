#===============================================================================
# Settings
#===============================================================================
module Settings
  #-----------------------------------------------------------------------------
  # Party Ball
  #-----------------------------------------------------------------------------
  # Enables the Party menu display of ball icons that match each Pokemon's ball.
  #-----------------------------------------------------------------------------
  SHOW_PARTY_BALL = true
  
  #-----------------------------------------------------------------------------
  # Shiny Leaf
  #-----------------------------------------------------------------------------
  # Enables the display of a Pokemon's collected Shiny Leaves in the Summary/Storage screens.
  #-----------------------------------------------------------------------------
  SUMMARY_SHINY_LEAF = true
  STORAGE_SHINY_LEAF = true
  
  #-----------------------------------------------------------------------------
  # IV Ratings
  #-----------------------------------------------------------------------------
  # Enables the display of star ratings for a Pokemon's IV's in the Summary/Storage screens.
  #-----------------------------------------------------------------------------
  SUMMARY_IV_RATINGS = true
  STORAGE_IV_RATINGS = true
  IV_DISPLAY_STYLE   = 0  # 0 = Stars, 1 = Letters
  
  #-----------------------------------------------------------------------------
  # Egg Groups
  #-----------------------------------------------------------------------------
  # Enables the display of icons indicating a Pokemon's Egg Groups in the Summary/Pokedex screens.
  #-----------------------------------------------------------------------------
  SUMMARY_EGG_GROUPS = true
  POKEDEX_EGG_GROUPS = true
  
  #-----------------------------------------------------------------------------
  # Battle UI Windows
  #-----------------------------------------------------------------------------
  # Keys used to toggle the display of in-battle UI windows.
  #-----------------------------------------------------------------------------
  MOVE_INFO_KEY   = :M
  BATTLE_INFO_KEY = :N
  
  #-----------------------------------------------------------------------------
  # Type Displays (Battle UI)
  #-----------------------------------------------------------------------------
  # Toggles whether type displays for unregistered species are shown in battle UI's.
  #-----------------------------------------------------------------------------
  ALWAYS_DISPLAY_TYPES = false
end