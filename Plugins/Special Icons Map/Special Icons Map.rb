#===============================================================================
# * Special Icons Map - by victordevjs (Credits will be apreciated)
#===============================================================================
#
# This script is for Pokémon Essentials. It displays icons on map based on a
# list of switches and custom icons.
#
#== INSTALLATION ===============================================================
#
# To this script works, put it above main OR convert into a plugin. On script 
# section UI_RegionMap, add line 'draw_special_icons_position(mapindex)' before line 
# 'if playerpos && mapindex == playerpos[0]' (it is 
# 'if playerpos && mapindex==playerpos[0]' in Essentials v19 and v19.1). 
#
# Put the desired icons on "Graphics/Pokemon/Map icons/X.png" where X is the 
# icon filename you specify in the SPECIAL_ICONS configuration below.
#
#===============================================================================

if !PluginManager.installed?("Special Icons Map")
  PluginManager.register({                                                 
    :name    => "Special Icons Map",                                        
    :version => "1.0.0",                                                     
    :link    => "https://victordejs.com",             
    :credits => "victordevjs"
  })
end

#===============================================================================
# Configuration - List of special icons to display on the map
#===============================================================================
# Each entry should have:
#   :name      - A descriptive name for the icon (for reference)
#   :switchOn  - The switch ID that must be ON for this icon to appear
#   :mapIndex  - The map ID where this icon should be displayed
#   :icon      - The filename of the icon (e.g., 'specialIcon1.png')
#===============================================================================
SPECIAL_ICONS = [
  {
    name: 'Den 1',
    switchOn: 831,
    mapIndex: 156,
    icon: 'den_red.png'
  },
    {
      name: 'Den 2',
      switchOn: 832,
      mapIndex: 591,
      icon: 'den_red.png'
    },
    {
    name: 'Den 3',
    switchOn: 833,
    mapIndex: 525,
    icon: 'den_red.png'
  },
  {
    name: 'Den 4',
    switchOn: 834,
    mapIndex: 534,
    icon: 'den_red.png'
  },
  {
    name: 'Den 5',
    switchOn: 835,
    mapIndex: 537,
    icon: 'den_red.png'
  },
  {
    name: 'Den 6',
    switchOn: 836,
    mapIndex: 541,
    icon: 'den_red.png'
  },
  {
    name: 'Den 7',
    switchOn: 837,
    mapIndex: 544,
    icon: 'den_red.png'
  },
  {
    name: 'Den 8',
    switchOn: 838,
    mapIndex: 549,
    icon: 'den_red.png'
  },
]

class PokemonRegionMap_Scene
  def draw_special_icons_position(mapindex)
    icon_index = 0
    for icon_config in SPECIAL_ICONS
      # Check if the switch is ON for this icon
      next if !$game_switches[icon_config[:switchOn]]
      
      # Get the map metadata for the specified map
      map_metadata = GameData::MapMetadata.try_get(icon_config[:mapIndex])
      next if !map_metadata
      
      # Get the town map position for this map
      town_map_pos = map_metadata.town_map_position
      next if !town_map_pos
      
      # Only draw if this icon is on the current map being displayed
      next if mapindex != town_map_pos[0]
      
      # Get the x and y coordinates from the town map position
      x = town_map_pos[1]
      y = town_map_pos[2]
      
      # Get the icon bitmap path
      icon_path = get_special_icon_path(icon_config[:icon])
      next if !icon_path
      
      # Create and position the icon sprite
      @sprites["special_icon#{icon_index}"] = IconSprite.new(0, 0, @viewport)
      @sprites["special_icon#{icon_index}"].setBitmap(icon_path)
      @sprites["special_icon#{icon_index}"].x = -SQUARE_WIDTH/2 + (x * SQUARE_WIDTH) + (
        Graphics.width - @sprites["map"].bitmap.width
      ) / 2
      @sprites["special_icon#{icon_index}"].y = -SQUARE_HEIGHT/2 + (y * SQUARE_HEIGHT) + (
        Graphics.height - @sprites["map"].bitmap.height
      ) / 2
      icon_index += 1
    end
  end
  
  def get_special_icon_path(icon_filename)
    path = "Graphics/Pictures/Pokegear/Map icons/"
    ret = pbResolveBitmap(path + icon_filename)
    return ret if ret
    # Fallback to default icon if specified icon doesn't exist
    return pbResolveBitmap(path + "000")
  end

  # Essentials v19 compatibility
  SQUARE_WIDTH = SQUAREWIDTH if !defined?(SQUARE_WIDTH)
  SQUARE_HEIGHT = SQUAREHEIGHT if !defined?(SQUARE_HEIGHT)
end