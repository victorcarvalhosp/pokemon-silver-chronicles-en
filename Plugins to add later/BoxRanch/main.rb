#===============================================================================
# * Box Ranch System
#===============================================================================

# Configuration is loaded automatically from config.rb

# Helper function to get the correct event name based on configuration
def get_ranch_event_name(species, in_water = false)
  if BoxRanchConfig::USE_REFLECTION_NAMES
    prefix = in_water ? BoxRanchConfig::WATER_EVENT_PREFIX_REFLECTION : BoxRanchConfig::LAND_EVENT_PREFIX_REFLECTION
  else
    prefix = in_water ? BoxRanchConfig::WATER_EVENT_PREFIX : BoxRanchConfig::LAND_EVENT_PREFIX
  end
  return "#{prefix}_#{species}"
end

# Helper function to load the correct Pokémon graphic
def box_ranch_sprite_filename(species, form = 0, gender = 0, shiny = false, in_water = false, levitates = false)
  fname = nil
  folder_extra = ""
  
  # Determine the correct folder based on the properties
  if in_water
    folder_extra = shiny ? "Swimming Shiny" : "Swimming"
  # elsif levitates
  #   folder_extra = shiny ? "Levitates Shiny" : "Levitates"
  else
    folder_extra = shiny ? "Followers shiny" : "Followers"
  end
  
  # Check various paths
  begin
    fname = GameData::Species.check_graphic_file("Graphics/Characters/", species, form, gender, shiny, false, folder_extra)
  rescue
    # Ignore errors and try another path
  end
  
  # Fallbacks
  if nil_or_empty?(fname)
    # Try directly with the name for the corresponding folder
    species_name = species.to_s
    fname = "Graphics/Characters/#{folder_extra}/#{species_name}"
    
    # If the file exists, use it
    if !pbResolveBitmap(fname)
      # Fallback to the standard folder if the special version doesn't exist
      if in_water || levitates
        # Try with the normal Followers folder
        fname = "Graphics/Characters/Followers/#{species_name}"
        if !pbResolveBitmap(fname)
          # Last fallback to standard sprite
          fname = "Graphics/Characters/Followers/000"
        end
      else
        # Use standard sprite
        fname = "Graphics/Characters/Followers/000"
      end
    end
  end
  
  return fname
end

# Helper function to check if a Pokémon is a Water type
def is_water_pokemon?(pokemon)
  return false if !pokemon
  
  # Check if the Pokémon has the Water type (using modern method)
  return pokemon.types.include?(:WATER)
end

# Helper function to check if a Pokémon can levitate
def is_levitating_pokemon?(pokemon)
  return false if !pokemon
  
  # List of Pokémon that can levitate
  levitating_species = [
    # Gen 1-3
    :GASTLY, :HAUNTER, :GENGAR, :KOFFING, :WEEZING, :PORYGON,
    :MISDREAVUS, :UNOWN, :NATU, :XATU, :ESPEON, :MURKROW, :WOBBUFFET,
    :GIRAFARIG, :PINECO, :DUNSPARCE, :GLIGAR, :LUGIA, :CELEBI,
    :DUSTOX, :SHEDINJA, :NINJASK, :WHISMUR, :LOUDRED, :EXPLOUD,
    :VOLBEAT, :ILLUMISE, :FLYGON, :BALTOY, :CLAYDOL, :LUNATONE, :SOLROCK,
    :CASTFORM, :SHUPPET, :BANETTE, :DUSKULL, :CHIMECHO, :GLALIE,
    :DEOXYS,
    # Gen 4+
    :BRONZOR, :BRONZONG, :DRIFLOON, :DRIFBLIM, :CHINGLING,
    :SPIRITOMB, :CARNIVINE, :ROTOM, :UXIE, :MESPRIT, :AZELF,
    :GIRATINA, :CRESSELIA, :DARKRAI,
    :YAMASK, :SIGILYPH, :SOLOSIS, :DUOSION, :REUNICLUS, :VANILLITE,
    :VANILLISH, :VANILLUXE, :EMOLGA, :TYNAMO, :EELEKTRIK, :EELEKTROSS,
    :CRYOGONAL, :HYDREIGON, :VOLCARONA,
    :VIKAVOLT, :CUTIEFLY, :RIBOMBEE, :COMFEY, :DHELMISE, :LUNALA,
    :NIHILEGO, :CELESTEELA, :KARTANA, :XURKITREE, :PHEROMOSA
  ]
  
  # List of levitating abilities
  levitating_abilities = [:LEVITATE, :AIRLOCK, :MAGNETRISE, :TELEPATHY]
  
  # Check if the Pokémon belongs to the list of levitating species or has a corresponding ability
  # FLYING-type Pokémon are NOT automatically considered levitating anymore
  return levitating_species.include?(pokemon.species) ||
         levitating_abilities.include?(pokemon.ability.id)
end

# Helper function to check if a tile is water
def is_water_tile?(x, y)
  return false if !$game_map
  
  # Check Terrain Tag
  terrain_tag = $game_map.terrain_tag(x, y)
  
  # Terrain tags for water are usually: 5 (deep water), 6 (shallow water), 7 (waterfall)
  return [5, 6, 7].include?(terrain_tag)
end

# Helper function to find water tiles on the map
def find_water_tiles(map_id = nil)
  map_id = $game_map.map_id if !map_id
  water_tiles = []
  
  # Scan the entire map for water tiles
  width = $game_map.width
  height = $game_map.height
  
  for x in 0...width
    for y in 0...height
      if is_water_tile?(x, y)
        water_tiles.push([x, y])
      end
    end
  end
  
  return water_tiles
end

# Helper function to find land tiles on the map
def find_land_tiles(map_id = nil)
  map_id = $game_map.map_id if !map_id
  land_tiles = []
  
  # Scan the entire map for land tiles (not water, passable)
  width = $game_map.width
  height = $game_map.height
  
  for x in 0...width
    for y in 0...height
      # Check if it's not water and is passable
      if !is_water_tile?(x, y) && $game_map.passable?(x, y, 0)
        land_tiles.push([x, y])
      end
    end
  end
  
  return land_tiles
end

# Helper function to play the Pokémon's cry
def play_pokemon_cry(pokemon, volume=90)
  return if !pokemon
  
  if pokemon.is_a?(Pokemon)
    if !pokemon.egg?
      GameData::Species.play_cry_from_pokemon(pokemon, volume)
    end
  else
    form = 0
    GameData::Species.play_cry_from_species(pokemon, form, volume)
  end
end

class BoxRanch
  attr_reader :pokemon_events  # Add access to pokemon_events

  def initialize
    @pokemon_events = {}    # Event-ID => Pokemon
    @pokemon_locations = {} # Pokemon => [box_index, slot_index] to track where pokemon come from
    @map_id = BoxRanchConfig::MAP_ID  # Ranch-Map ID from config
    @water_tiles = []       # List of water tiles
    @land_tiles = []        # List of land tiles
    
    echoln("BoxRanch: NEW BoxRanch object created with ID #{self.object_id}")
  end

  def setup
    # Check the current map ID and scene type
    echoln("BoxRanch: setup() called")
    return if !$game_map
    current_map_id = $game_map.map_id
    echoln("BoxRanch: Current map: #{current_map_id}, Ranch map: #{@map_id}, Scene: #{$scene.class}")
    
    # Only call setup_ranch_pokemon if the Map ID is correct 
    # Accept Scene_Map OR Scene_DebugIntro (which happens after loading)
    if current_map_id == @map_id && ($scene.is_a?(Scene_Map) || $scene.is_a?(Scene_DebugIntro))
      echoln("BoxRanch: Conditions met, calling setup_ranch_pokemon")
      setup_ranch_pokemon
    else
      echoln("BoxRanch: Conditions not met - skipping setup (Map: #{current_map_id}, Target: #{@map_id}, Scene: #{$scene.class})")
    end
  end

  def setup_ranch_pokemon
    return if $game_map.map_id != @map_id
    
    # Block autosave during setup
    # $game_temp.no_autosave = true if $game_temp
    
    # Debug output
    echoln("BoxRanch: Starting setup for map #{$game_map.map_id}")
    
    # First, delete all existing events
    clear_ranch_pokemon
    
    # Then identify the water and land tiles
    @water_tiles = find_water_tiles
    @land_tiles = find_land_tiles
    
    # Debug tile information
    echoln("BoxRanch: Found #{@water_tiles.length} water tiles and #{@land_tiles.length} land tiles")
    
    # Clear location tracking
    @pokemon_locations.clear
    
    # Then load all Pokémon from the box and track their locations
    pokemon_list = []
    
    for i in 0...$PokemonStorage.maxBoxes
      for j in 0...$PokemonStorage.maxPokemon(i)
        pkmn = $PokemonStorage[i,j]
        if pkmn
          pokemon_list.push(pkmn)
          @pokemon_locations[pkmn] = [i, j]  # Track box and slot
        end
      end
    end
    
    # Debug pokemon count
    echoln("BoxRanch: Found #{pokemon_list.length} Pokemon in boxes")
    
    # Create test Pokémon if enabled and no pokemon exist
    if pokemon_list.empty? && BoxRanchConfig::CREATE_TEST_POKEMON
      echoln("BoxRanch: Creating test Pokemon")
      test_pokemon = Pokemon.new(BoxRanchConfig::TEST_LAND_SPECIES, BoxRanchConfig::TEST_LEVEL)
      pokemon_list.push(test_pokemon)
      # Note: Test pokemon are NOT added to @pokemon_locations since they're not in boxes
      
      # Also add a water Pokémon if water tiles exist
      if !@water_tiles.empty?
        water_test = Pokemon.new(BoxRanchConfig::TEST_WATER_SPECIES, BoxRanchConfig::TEST_LEVEL)
        pokemon_list.push(water_test)
        # Note: Test pokemon are NOT added to @pokemon_locations since they're not in boxes
      end
      echoln("BoxRanch: Created #{pokemon_list.length} test Pokemon")
    end
    
    # Sort Pokémon into water and land Pokémon
    water_pokemon = []
    land_pokemon = []
    
    pokemon_list.each do |pkmn|
      if is_water_pokemon?(pkmn) && !@water_tiles.empty?
        water_pokemon.push(pkmn)
      else
        land_pokemon.push(pkmn)
      end
    end
    
    # Debug pokemon categorization
    echoln("BoxRanch: #{land_pokemon.length} land Pokemon, #{water_pokemon.length} water Pokemon")
    
    # Create events for land Pokémon
    max_land = [land_pokemon.size, BoxRanchConfig::MAX_LAND_POKEMON].min
    echoln("BoxRanch: Creating #{max_land} land Pokemon events")
    land_pokemon[0...max_land].each_with_index do |pkmn, index|
      create_pokemon_event(pkmn, index, false)
    end
    
    # Create events for water Pokémon
    max_water = [water_pokemon.size, BoxRanchConfig::MAX_WATER_POKEMON].min
    echoln("BoxRanch: Creating #{max_water} water Pokemon events")
    water_pokemon[0...max_water].each_with_index do |pkmn, index|
      create_pokemon_event(pkmn, index, true)
    end
    
    echoln("BoxRanch: Setup complete! Total events created: #{@pokemon_events.size}")
    
    # Refresh Following Pokemon to ensure it reappears after changes
    if defined?(FollowingPkmn)
      FollowingPkmn.refresh(false)
    end
    
    # Re-enable autosave after setup
    # $game_temp.no_autosave = false if $game_temp
  end

  def create_pokemon_event(pkmn, index, in_water = false)
    echoln("BoxRanch: Creating event for #{pkmn.name} (#{pkmn.species}) at index #{index}, in_water: #{in_water}")
    
    # Determine position based on water/land
    x = 0
    y = 0
    
    if in_water
      # Choose random position from the water tiles
      if !@water_tiles.empty?
        pos = @water_tiles.sample
        x, y = pos
        # Remove the position so that multiple Pokémon are not in the same place
        @water_tiles.delete(pos)
      else
        # Fallback: Grid positioning as before
        ranch_area = {
          x_start: 30, y_start: 30, width: 15, height: 15, columns: 3, rows: 4
        }
        
        column = index % ranch_area[:columns]
        row = (index / ranch_area[:columns]) % ranch_area[:rows]
        
        cell_width = ranch_area[:width] / ranch_area[:columns]
        cell_height = ranch_area[:height] / ranch_area[:rows]
        
        x = ranch_area[:x_start] + (column * cell_width) + rand(cell_width / 2)
        y = ranch_area[:y_start] + (row * cell_height) + rand(cell_height / 2)
      end
    else
      # For land Pokémon
      if !@land_tiles.empty?
        # Choose random land tile
        pos = @land_tiles.sample
        x, y = pos
        # Remove the position
        @land_tiles.delete(pos)
      else
        # Fallback: Grid positioning
        ranch_area = {
          x_start: 30, y_start: 30, width: 15, height: 15, columns: 3, rows: 4
        }
        
        column = index % ranch_area[:columns]
        row = (index / ranch_area[:columns]) % ranch_area[:rows]
        
        cell_width = ranch_area[:width] / ranch_area[:columns]
        cell_height = ranch_area[:height] / ranch_area[:rows]
        
        x = ranch_area[:x_start] + (column * cell_width) + rand(cell_width / 2)
        y = ranch_area[:y_start] + (row * cell_height) + rand(cell_height / 2)
      end
    end
    
    # Check if the Pokémon can levitate
    levitates = is_levitating_pokemon?(pkmn)
    
    # Determine sprite names
    species_name = pkmn.species.to_s
    form = pkmn.form || 0
    gender = pkmn.gender
    shiny = pkmn.shiny?
    
    # Try to get the correct sprite, considering water/levitates
    sprite_path = box_ranch_sprite_filename(pkmn.species, form, gender, shiny, in_water, levitates)
    sprite_name = sprite_path.gsub("Graphics/Characters/", "")
    
    # Create event
    event = RPG::Event.new(x, y)
    # Find a safe event ID that doesn't conflict with existing events or Following Pokemon
    existing_ids = $game_map.events.keys
    event.id = existing_ids.empty? ? 1000 : [existing_ids.max + 1, 1000].max
    
    # Set event name using configuration (for plugin compatibility)
    event.name = get_ranch_event_name(pkmn.species, in_water)
    
    # Set graphic
    event.pages[0].graphic.character_name = sprite_name
    event.pages[0].graphic.character_hue = 0
    event.pages[0].graphic.direction = 2  # Down
    
    # Simple settings for reliable display
    event.pages[0].through = false       # Cannot be walked through
    event.pages[0].always_on_top = false # Do NOT always display on top, so it looks natural
    event.pages[0].step_anime = true     # Standing animation
    event.pages[0].trigger = 0           # Action button (0 = interaction only when pressing A)
    
    # Add movement settings
    event.pages[0].move_type = 1        # 1 = Random movement
    
    # Calculate nature-dependent speed and frequency using configuration
    # Convert nature.id (symbol) to an integer value for the calculation
    nature_value = pkmn.nature.id.to_s.hash.abs
    
    # Set speed based on configuration and pokemon environment
    if in_water
      speed_range = BoxRanchConfig::WATER_SPEED_MAX - BoxRanchConfig::WATER_SPEED_MIN + 1
      event.pages[0].move_speed = BoxRanchConfig::WATER_SPEED_MIN + (nature_value % speed_range)
    else
      speed_range = BoxRanchConfig::LAND_SPEED_MAX - BoxRanchConfig::LAND_SPEED_MIN + 1
      event.pages[0].move_speed = BoxRanchConfig::LAND_SPEED_MIN + (nature_value % speed_range)
    end
    
    # Set frequency based on configuration
    freq_range = BoxRanchConfig::FREQUENCY_MAX - BoxRanchConfig::FREQUENCY_MIN + 1
    event.pages[0].move_frequency = BoxRanchConfig::FREQUENCY_MIN + (nature_value % freq_range)
    
    # Settings for autonomous movement
    event.pages[0].move_route = RPG::MoveRoute.new
    event.pages[0].move_route.repeat = true
    event.pages[0].move_route.skippable = false
    event.pages[0].move_route.list = []
    
    # Event commands
    event.pages[0].list = []  # Empty list
    
    # Now add commands
    # Play the Pokémon's cry - use symbol notation
    Compiler::push_script(event.pages[0].list, "play_pokemon_cry(:#{pkmn.species}, 100)")
    
    # Display of information
    Compiler::push_script(event.pages[0].list, "pbMessage(\"#{pkmn.name} looks at you friendly!\")")
    
    # More interactive details
    if pkmn.shiny?
      Compiler::push_script(event.pages[0].list, "pbMessage(\"#{pkmn.name} shines conspicuously in the sunlight.\")")
    end
    
    # Character info based on nature
    nature_text = get_nature_text(pkmn.nature)
    Compiler::push_script(event.pages[0].list, "pbMessage(\"#{nature_text}\")")
    
    # Special messages based on environment
    if in_water
      Compiler::push_script(event.pages[0].list, "pbMessage(\"It swims happily in the water!\")")
    elsif levitates
      Compiler::push_script(event.pages[0].list, "pbMessage(\"It floats elegantly in the air!\")")
    end
    
    # Level and other details
    Compiler::push_script(event.pages[0].list, "pbMessage(\"Level: #{pkmn.level}\\nAbility: #{pkmn.ability.name}\")")
    
    # Optional: Show menu - use symbol notation and pass event_id
    Compiler::push_script(event.pages[0].list, "show_pokemon_interaction_menu(:#{pkmn.species}, #{pkmn.level}, #{event.id})")
    
    Compiler::push_end(event.pages[0].list)
    
    # Add event to the map
    game_event = Game_Event.new($game_map.map_id, event)
    
    # Set position directly
    game_event.moveto(x, y)
    
    # Start the event's movement
    game_event.refresh
    
    $game_map.events[event.id] = game_event
    
    # Save Pokémon reference
    @pokemon_events[event.id] = pkmn
    
    echoln("BoxRanch: Successfully created event #{event.id} for #{pkmn.name} at position (#{x}, #{y})")
    echoln("BoxRanch: @pokemon_events now contains #{@pokemon_events.size} events: #{@pokemon_events.keys}")
    
    return game_event
  end

  def clear_ranch_pokemon
    echoln("BoxRanch: Clearing #{@pokemon_events.size} existing ranch Pokemon events")
    
    event_ids_to_remove = []
    
    @pokemon_events.each_key do |event_id|
      event_ids_to_remove.push(event_id)
    end
    
    event_ids_to_remove.each do |event_id|
      if $game_map.events[event_id]
        $game_map.events.delete(event_id)
      end
    end
    
    # CRITICAL: Also clean up any leftover ranch events (ID >= 1000)
    # This handles old events that survived previous clears
    old_events_removed = []
    $game_map.events.each do |event_id, event|
      if event_id >= 1000
        echoln("BoxRanch: Found leftover ranch event #{event_id}, removing")
        old_events_removed << event_id
      end
    end
    
    old_events_removed.each do |event_id|
      $game_map.events.delete(event_id)
    end
    
    @pokemon_events.clear
    @pokemon_locations.clear
    
    echoln("BoxRanch: Cleared all ranch events")
    
    # Refresh Following Pokemon to ensure it reappears after changes
    if defined?(FollowingPkmn)
      FollowingPkmn.refresh(false)
    end
  end

  def update
    # No update needed, as the events update themselves
  end
  
  private
  
  # Helper method for nature-dependent text
  def get_nature_text(nature)
    # Descriptions for different natures
    nature_texts = {
      # Jolly natures
      :JOLLY => "It dances around cheerfully.",
      :NAIVE => "It is very playful.",
      :HASTY => "It can't stand still and is constantly running around.",
      # Calm natures
      :CALM => "It rests peacefully.",
      :CAREFUL => "It attentively observes its surroundings.",
      :QUIET => "It enjoys the tranquility of the ranch.",
      # Aggressive natures
      :BRAVE => "It bravely shows itself off.",
      :ADAMANT => "It trains its muscles.",
      :NAUGHTY => "It seems to be up to something."
    }
    
    # Standard text if nature is not defined
    return nature_texts[nature.id] || "It feels very comfortable on the ranch."
  end

  def create_pokemon_event_at(pkmn, x, y, in_water = false)
    echoln("BoxRanch: Creating event_at for #{pkmn.name} (#{pkmn.species}) at position (#{x}, #{y}), in_water: #{in_water}")
    
    # Check if the Pokémon can levitate
    levitates = is_levitating_pokemon?(pkmn)
    
    # Determine sprite names
    species_name = pkmn.species.to_s
    form = pkmn.form || 0
    gender = pkmn.gender
    shiny = pkmn.shiny?
    
    # Try to get the correct sprite, considering water/levitates
    sprite_path = box_ranch_sprite_filename(pkmn.species, form, gender, shiny, in_water, levitates)
    sprite_name = sprite_path.gsub("Graphics/Characters/", "")
    
    # Create event
    event = RPG::Event.new(x, y)
    # Find a safe event ID that doesn't conflict with existing events or Following Pokemon
    existing_ids = $game_map.events.keys
    event.id = existing_ids.empty? ? 1000 : [existing_ids.max + 1, 1000].max
    
    # Set event name using configuration (for plugin compatibility)
    event.name = get_ranch_event_name(pkmn.species, in_water)
    
    # Set graphic
    event.pages[0].graphic.character_name = sprite_name
    event.pages[0].graphic.character_hue = 0
    event.pages[0].graphic.direction = 2  # Down
    
    # Simple settings for reliable display
    event.pages[0].through = false       # Cannot be walked through
    event.pages[0].always_on_top = false # Do NOT always display on top, so it looks natural
    event.pages[0].step_anime = true     # Standing animation
    event.pages[0].trigger = 0           # Action button (0 = interaction only when pressing A)
    
    # Add movement settings
    event.pages[0].move_type = 1        # 1 = Random movement
    
    # Calculate nature-dependent speed and frequency using configuration
    # Convert nature.id (symbol) to an integer value for the calculation
    nature_value = pkmn.nature.id.to_s.hash.abs
    
    # Set speed based on configuration and pokemon environment
    if in_water
      speed_range = BoxRanchConfig::WATER_SPEED_MAX - BoxRanchConfig::WATER_SPEED_MIN + 1
      event.pages[0].move_speed = BoxRanchConfig::WATER_SPEED_MIN + (nature_value % speed_range)
    else
      speed_range = BoxRanchConfig::LAND_SPEED_MAX - BoxRanchConfig::LAND_SPEED_MIN + 1
      event.pages[0].move_speed = BoxRanchConfig::LAND_SPEED_MIN + (nature_value % speed_range)
    end
    
    # Set frequency based on configuration
    freq_range = BoxRanchConfig::FREQUENCY_MAX - BoxRanchConfig::FREQUENCY_MIN + 1
    event.pages[0].move_frequency = BoxRanchConfig::FREQUENCY_MIN + (nature_value % freq_range)
    
    # Settings for autonomous movement
    event.pages[0].move_route = RPG::MoveRoute.new
    event.pages[0].move_route.repeat = true
    event.pages[0].move_route.skippable = false
    event.pages[0].move_route.list = []
    
    # Event commands
    event.pages[0].list = []  # Empty list
    
    # Now add commands
    # Play the Pokémon's cry - use symbol notation
    Compiler::push_script(event.pages[0].list, "play_pokemon_cry(:#{pkmn.species}, 100)")
    
    # Display of information
    Compiler::push_script(event.pages[0].list, "pbMessage(\"#{pkmn.name} looks at you friendly!\")")
    
    # More interactive details
    if pkmn.shiny?
      Compiler::push_script(event.pages[0].list, "pbMessage(\"#{pkmn.name} shines conspicuously in the sunlight.\")")
    end
    
    # Character info based on nature
    nature_text = get_nature_text(pkmn.nature)
    Compiler::push_script(event.pages[0].list, "pbMessage(\"#{nature_text}\")")
    
    # Special messages based on environment
    if in_water
      Compiler::push_script(event.pages[0].list, "pbMessage(\"It swims happily in the water!\")")
    elsif levitates
      Compiler::push_script(event.pages[0].list, "pbMessage(\"It floats elegantly in the air!\")")
    end
    
    # Level and other details
    Compiler::push_script(event.pages[0].list, "pbMessage(\"Level: #{pkmn.level}\\nAbility: #{pkmn.ability.name}\")")
    
    # Optional: Show menu - use symbol notation and pass event_id
    Compiler::push_script(event.pages[0].list, "show_pokemon_interaction_menu(:#{pkmn.species}, #{pkmn.level}, #{event.id})")
    
    Compiler::push_end(event.pages[0].list)
    
    # Add event to the map
    game_event = Game_Event.new($game_map.map_id, event)
    
    # Set position directly
    game_event.moveto(x, y)
    
    # Start the event's movement
    game_event.refresh
    
    $game_map.events[event.id] = game_event
    
    # Save Pokémon reference
    @pokemon_events[event.id] = pkmn
    
    echoln("BoxRanch: Successfully created event #{event.id} for #{pkmn.name} at position (#{x}, #{y})")
    echoln("BoxRanch: @pokemon_events now contains #{@pokemon_events.size} events: #{@pokemon_events.keys}")
    
    return game_event
  end
  
  def remove_pokemon_event(event_id)
    # Block autosave during critical operations
    # $game_temp.no_autosave = true if $game_temp
    
    echoln("BoxRanch: Removing event #{event_id}")
    echoln("BoxRanch: @pokemon_events before removal: #{@pokemon_events.keys}")
    
    # Remove event from the map
    if $game_map.events[event_id]
      $game_map.events.delete(event_id)
    end
    
    # Remove reference from pokemon_events
    @pokemon_events.delete(event_id)
    
    # CRITICAL: Hybrid solution - strong enough for ghosts, safe for follower
    echoln("BoxRanch: Hybrid sprite refresh - eliminating ghost sprites safely")
    
    # Small delay for event processing
    pbWait((0.1*60).round)
    
    # Store Following Pokemon data and completely preserve it
    follower_data = nil
    follower_was_active = false
    follower_event_backup = nil
    
    if defined?(FollowingPkmn) && FollowingPkmn.active?
      follower_event = FollowingPkmn.get_event
      follower_was_active = true
      
      # Create comprehensive backup of Following Pokemon state
      follower_data = {
        x: follower_event&.x,
        y: follower_event&.y,
        direction: follower_event&.direction,
        character_name: follower_event&.character_name,
        character_hue: follower_event&.character_hue,
        pattern: follower_event&.pattern,
        opacity: follower_event&.opacity,
        blend_type: follower_event&.blend_type
      }
      echoln("BoxRanch: Complete Following Pokemon backup: #{follower_data}")
      
      # Store the follower toggled state
      follower_toggled_backup = $PokemonGlobal.follower_toggled if $PokemonGlobal
    end
    
    # PERFECT SOLUTION: Map transfer with Following Pokemon protection
    echoln("BoxRanch: Perfect map transfer - eliminating ALL ghost sprites")
    
    # Store current position and map
    current_map_id = $game_map.map_id
    current_x = $game_player.x
    current_y = $game_player.y
    current_direction = $game_player.direction
    
    echoln("BoxRanch: Stored player position: Map #{current_map_id}, (#{current_x}, #{current_y}), Dir #{current_direction}")
    
    # Prepare map transfer to same position (this forces COMPLETE refresh)
    $game_temp.player_new_map_id = current_map_id
    $game_temp.player_new_x = current_x
    $game_temp.player_new_y = current_y
    $game_temp.player_new_direction = current_direction
    $game_temp.player_transferring = true
    
    echoln("BoxRanch: Map transfer prepared - processing now")
    
    # Process the transfer immediately
    if $scene && $scene.respond_to?(:transfer_player)
      $scene.transfer_player
    end
    
    echoln("BoxRanch: Map transfer completed - all sprites refreshed")
    
    # Restore Following Pokemon immediately and completely
    if follower_was_active && defined?(FollowingPkmn)
      echoln("BoxRanch: Immediately restoring Following Pokemon")
      
      # Restore the toggled state first
      if $PokemonGlobal && follower_toggled_backup != nil
        $PokemonGlobal.follower_toggled = follower_toggled_backup
      end
      
      # Force refresh with no animation to avoid flicker
      FollowingPkmn.refresh(false) if FollowingPkmn.respond_to?(:refresh)
      
      # Small delay to ensure follower is back
      pbWait((0.05*60).round)
    end
    
    echoln("BoxRanch: @pokemon_events after removal: #{@pokemon_events.keys}")
    echoln("BoxRanch: Event #{event_id} removed from tracking")
    
    # Re-enable autosave
    # $game_temp.no_autosave = false if $game_temp
  end
  
  def refresh_sprites
    # Refresh Following Pokemon to ensure it reappears after changes
    if defined?(FollowingPkmn)
      FollowingPkmn.refresh(false)
    end
  end
end

# Debug function to manually trigger ranch setup
def debug_ranch_setup
  echoln("DEBUG: Manual ranch setup called")
  if !$box_ranch
    echoln("DEBUG: Creating new BoxRanch")
    $box_ranch = BoxRanch.new
  end
  echoln("DEBUG: Current BoxRanch object ID: #{$box_ranch.object_id}")
  echoln("DEBUG: Current map: #{$game_map.map_id}")
  echoln("DEBUG: Calling setup")
  $box_ranch.setup
  echoln("DEBUG: Setup complete. Events: #{$box_ranch.pokemon_events.size}")
end

# Function to display an interaction menu
def show_pokemon_interaction_menu(species, level, event_id = nil)
  # Add debug output
  echoln("DEBUG: show_pokemon_interaction_menu called with event_id=#{event_id}")
  echoln("DEBUG: $player exists: #{$player ? 'Yes' : 'No'}")
  echoln("DEBUG: $box_ranch exists: #{$box_ranch ? 'Yes' : 'No'}")
  echoln("DEBUG: Current map ID: #{$game_map.map_id}")
  echoln("DEBUG: Ranch map ID: #{BoxRanchConfig::MAP_ID}")
  
  if $box_ranch && event_id
    echoln("DEBUG: Event exists in pokemon_events: #{$box_ranch.pokemon_events[event_id] ? 'Yes' : 'No'}")
    echoln("DEBUG: All pokemon_events keys: #{$box_ranch.pokemon_events.keys}")
    echoln("DEBUG: pokemon_events size: #{$box_ranch.pokemon_events.size}")
    echoln("DEBUG: BoxRanch object ID: #{$box_ranch.object_id}")
  end
  
  # Always show standard options
  commands = [
    _INTL("Pet"),
    _INTL("Feed"),
    _INTL("Play")
  ]
  
  # Check team status and add appropriate options
  if $player && $player.party
    party_size = $player.party.length
    if party_size < Settings::MAX_PARTY_SIZE  # Team not full
      commands.push(_INTL("Take to team"))
      if party_size > 0  # Also offer swap if team has Pokemon
        commands.push(_INTL("Swap with team"))
      end
    else  # Team is full
      commands.push(_INTL("Swap with team"))
    end
  end
  
  commands.push(_INTL("Back"))
  
  choice = pbMessage(_INTL("What would you like to do?"), commands, commands.length)
  
  if choice == 0  # Pet
    pbMessage(_INTL("You gently pet the Pokémon. It seems to enjoy that!"))
    play_pokemon_cry(species, 70)  # Quieter cry
  elsif choice == 1  # Feed
    pbMessage(_INTL("You give the Pokémon some food. It eats happily!"))
  elsif choice == 2  # Play
    pbMessage(_INTL("You play with the Pokémon for a while. It has fun!"))
    play_pokemon_cry(species, 100)
  elsif commands[choice] == _INTL("Take to team")  # Take to team
    if $player && event_id && $box_ranch && $box_ranch.pokemon_events[event_id]
      take_to_party(event_id)
    else
      display_interaction_error(event_id)
    end
  elsif commands[choice] == _INTL("Swap with team")  # Swap with team
    if $player && event_id && $box_ranch && $box_ranch.pokemon_events[event_id]
      swap_with_party_pokemon(event_id)
    else
      display_interaction_error(event_id)
    end
  else  # Back or invalid selection
    # Do nothing
  end
end

# Helper function to display error messages
def display_interaction_error(event_id)
  if !$player
    pbMessage(_INTL("Action not possible. Player data not available."))
  elsif !event_id
    pbMessage(_INTL("Action not possible. Event ID missing."))
  elsif !$box_ranch
    pbMessage(_INTL("Action not possible. Box Ranch not initialized."))
  elsif !$box_ranch.pokemon_events[event_id]
    pbMessage(_INTL("Action not possible. Pokémon not found."))
  else
    pbMessage(_INTL("Action not possible for unknown reason."))
  end
end

# Function to take a Ranch Pokémon to the party
def take_to_party(event_id)
  # Debug output
  echoln("DEBUG: take_to_party called with event_id=#{event_id}")
  
  return if !$box_ranch || !$box_ranch.pokemon_events[event_id]
  
  # Retrieve Ranch Pokémon
  ranch_pokemon = $box_ranch.pokemon_events[event_id]
  echoln("DEBUG: Ranch Pokémon found: #{ranch_pokemon ? ranch_pokemon.name : 'None'}")
  
  # Check if $player exists
  if !$player
    echoln("DEBUG: $player does not exist!")
    pbMessage(_INTL("Take not possible. Player data not available."))
    return
  end
  
  # Check if the team has space
  if $player.party.length >= Settings::MAX_PARTY_SIZE
    pbMessage(_INTL("Your team is full. You can't take more Pokémon."))
    return
  end
  
  # Get the box location of the ranch pokemon (if it exists)
  ranch_box_location = $box_ranch.instance_variable_get(:@pokemon_locations)[ranch_pokemon]
  
  # Display confirmation
  msg = _INTL("Do you want to take {1} (Lv. {2}) to your team?",
    ranch_pokemon.name, ranch_pokemon.level)
  
  if pbConfirmMessage(msg)
    # Save position information from the event (before we remove it)
    event = $game_map.events[event_id]
    
    # 1. Add ranch pokemon to party
    $player.party.push(ranch_pokemon)
    
    # 2. If ranch pokemon came from box, remove it from that box slot
    if ranch_box_location
      box_index, slot_index = ranch_box_location
      $PokemonStorage[box_index, slot_index] = nil
      # Remove location tracking
      $box_ranch.instance_variable_get(:@pokemon_locations).delete(ranch_pokemon)
    end
    
    # 3. Remove the event
    $box_ranch.remove_pokemon_event(event_id)
    
    # Success message
    pbMessage(_INTL("{1} joined your team!", ranch_pokemon.name))
    
    # Force map refresh to eliminate any remaining ghost sprites
    echoln("BoxRanch: Forcing map refresh after take_to_party")
    $game_map.need_refresh = true
    $game_map.refresh
    pbWait((0.1*60).round)
      
    # Refresh Following Pokemon if active
    if defined?(FollowingPkmn) && FollowingPkmn.active?
      FollowingPkmn.refresh(false)
    end
  else
    pbMessage(_INTL("Take cancelled."))
  end
end

# Function to swap a Ranch Pokémon with one from the team
def swap_with_party_pokemon(event_id)
  # Debug output
  echoln("DEBUG: swap_with_party_pokemon called with event_id=#{event_id}")
  
  return if !$box_ranch || !$box_ranch.pokemon_events[event_id]
  
  # Retrieve Ranch Pokémon
  ranch_pokemon = $box_ranch.pokemon_events[event_id]
  echoln("DEBUG: Ranch Pokémon found: #{ranch_pokemon ? ranch_pokemon.name : 'None'}")
  
  # Check if $player exists
  if !$player
    echoln("DEBUG: $player does not exist!")
    pbMessage(_INTL("Swap not possible. Player data not available."))
    return
  end
  
  # Check if the player has any Pokémon in the team at all
  if !$player.party || $player.party.empty?
    echoln("DEBUG: No Pokémon found in the team!")
    pbMessage(_INTL("You have no Pokémon in your team to swap with."))
    return
  end
  
  # Select team Pokémon
  pbMessage(_INTL("Choose a Pokémon from your team to swap with."))
  
  # Use temporary game variables for the selection
  chosen_var = 1 # Game variable 1 for the selection
  name_var = 2   # Game variable 2 for the name
  
  # Call the Pokémon selection screen
  pbChoosePokemon(chosen_var, name_var)
  
  # Read the selected number from the game variable
  chosen_index = $game_variables[chosen_var]
  echoln("DEBUG: Selected index from variable #{chosen_var}: #{chosen_index}")
  
  # If cancelled or no valid Pokémon
  if chosen_index < 0 || chosen_index >= $player.party.length
    pbMessage(_INTL("Swap cancelled."))
    return
  end
  
  # The selected team Pokémon
  party_pokemon = $player.party[chosen_index]
  
  # Display Pokémon details and get confirmation
  msg = _INTL("Do you want to swap {1} (Lv. {2}) with {3} (Lv. {4})?",
    ranch_pokemon.name, ranch_pokemon.level, party_pokemon.name, party_pokemon.level)
  
  if pbConfirmMessage(msg)
    # Save position information from the event (before we remove it)
    event = $game_map.events[event_id]
    x = event.x
    y = event.y
    in_water = event.name.include?("InWater")
    
    # Get the box location of the ranch pokemon (if it exists)
    ranch_box_location = $box_ranch.instance_variable_get(:@pokemon_locations)[ranch_pokemon]
    
    # Perform the swap
    # 1. Replace team Pokémon with the Ranch Pokémon
    $player.party[chosen_index] = ranch_pokemon
    
    # 2. If ranch pokemon came from box, put party pokemon in that box slot
    if ranch_box_location
      box_index, slot_index = ranch_box_location
      $PokemonStorage[box_index, slot_index] = party_pokemon
      # Update location tracking
      $box_ranch.instance_variable_get(:@pokemon_locations)[party_pokemon] = [box_index, slot_index]
      $box_ranch.instance_variable_get(:@pokemon_locations).delete(ranch_pokemon)
    end
    
    # 3. Remove the old event and create new one
    $box_ranch.remove_pokemon_event(event_id)
    
    # Small delay to ensure removal is processed
    pbWait((0.1*60).round)
    
    $box_ranch.create_pokemon_event_at(party_pokemon, x, y, in_water)
    
    # Success message
    pbMessage(_INTL("Swap successful! {1} is now in your team, and {2} is on the Ranch.",
      ranch_pokemon.name, party_pokemon.name))
    
    # Force map refresh to eliminate any remaining ghost sprites
    echoln("BoxRanch: Forcing map refresh after swap")
    $game_map.need_refresh = true
    $game_map.refresh
    pbWait((0.1*60).round)
      
    # Refresh Following Pokemon if active
    if defined?(FollowingPkmn) && FollowingPkmn.active?
      FollowingPkmn.refresh(false)
    end
  else
    pbMessage(_INTL("Swap cancelled."))
  end
end

# Create BoxRanch instance and generate events when the map is loaded
EventHandlers.add(:on_map_change, :setup_box_ranch, proc { |_old_map_id|
  begin
    $box_ranch = BoxRanch.new if !$box_ranch
    $box_ranch.setup if $box_ranch
  rescue => e
    echoln("BoxRanch Error in on_map_change: #{e.message}")
    echoln(e.backtrace.join("\n"))
  end
})

# Initialize BoxRanch on startup and after loading
EventHandlers.add(:on_game_load, :init_box_ranch, proc {
  begin
    echoln("BoxRanch: *** on_game_load EVENT TRIGGERED ***")
    echoln("BoxRanch: Game loaded, initializing BoxRanch")
    $box_ranch = BoxRanch.new if !$box_ranch
    # Setup ranch if we're currently on the ranch map
    if $game_map && $game_map.map_id == BoxRanchConfig::MAP_ID
      echoln("BoxRanch: Currently on ranch map, setting up events")
      
      # Force a map refresh first to ensure clean state
      echoln("BoxRanch: Forcing map refresh on load")
      $game_map.need_refresh = true
      $game_map.refresh
      
      # Small delay for refresh to complete
      pbWait((0.1*60).round)
      
      # Now setup events
      $box_ranch.setup
      
      echoln("BoxRanch: Load setup complete - events: #{$box_ranch.pokemon_events.size}")
    else
      echoln("BoxRanch: Not on ranch map (current: #{$game_map ? $game_map.map_id : 'nil'}, ranch: #{BoxRanchConfig::MAP_ID})")
    end
  rescue => e
    echoln("BoxRanch Error in on_game_load: #{e.message}")
    echoln(e.backtrace.join("\n"))
  end
})

# Additional handler for map scenes
EventHandlers.add(:on_enter_map, :box_ranch_map_enter, proc { |old_map_id|
  if $game_map && $game_map.map_id == BoxRanchConfig::MAP_ID
    echoln("BoxRanch: *** Entered ranch map - triggering setup ***")
    $box_ranch = BoxRanch.new if !$box_ranch
    # Small delay to ensure map is fully loaded
    pbWait((0.1*60).round)
    $box_ranch.setup if $box_ranch
  end
})

# Additional handler for scene changes (more reliable for save/load)
class Scene_Map
  alias box_ranch_update_for_save update
  def update
    box_ranch_update_for_save
    
    # Check if we need to setup ranch after scene is ready
    if $game_map && $game_map.map_id == BoxRanchConfig::MAP_ID && 
       $box_ranch && $box_ranch.pokemon_events.empty? && 
       !$game_temp.in_battle && !$game_temp.in_menu
      echoln("BoxRanch: *** Scene ready - triggering delayed setup ***")
      
      # Force map refresh first
      $game_map.need_refresh = true
      $game_map.refresh
      
      # Small delay then setup
      pbWait((0.1*60).round)
      $box_ranch.setup
      
      echoln("BoxRanch: Delayed setup complete - events: #{$box_ranch.pokemon_events.size}")
    end
  end
end

# Sync ranch when accessing PC
EventHandlers.add(:on_box_change, :sync_box_ranch, proc { |_old_box|
  if $box_ranch && $game_map && $game_map.map_id == BoxRanchConfig::MAP_ID
    # Re-setup ranch when box contents change
    $box_ranch.setup
  end
})

#===============================================================================
# * Game_Map
#===============================================================================

class Game_Map
  alias box_ranch_setup setup
  def setup(map_id)
    echoln("BoxRanch: *** Game_Map#setup called with map_id=#{map_id} ***")
    box_ranch_setup(map_id)
    # Ensure BoxRanch is initialized and setup
    echoln("BoxRanch: Initializing BoxRanch in Game_Map#setup")
    $box_ranch = BoxRanch.new if !$box_ranch
    if $box_ranch
      echoln("BoxRanch: Calling setup from Game_Map#setup")
      $box_ranch.setup
    else
      echoln("BoxRanch: ERROR - $box_ranch is nil!")
    end
  end
end

#===============================================================================
# * Scene_Map
#===============================================================================

class Scene_Map
  alias box_ranch_main main
  def main
    echoln("BoxRanch: *** Scene_Map#main called ***")
    box_ranch_main
    # Setup ranch when entering map scene
    if $game_map && $game_map.map_id == BoxRanchConfig::MAP_ID
      echoln("BoxRanch: In Scene_Map#main on ranch map - setting up")
      $box_ranch = BoxRanch.new if !$box_ranch
      $box_ranch.setup if $box_ranch
    end
  end
end

class Scene_Map
  alias box_ranch_update update
  def update
    box_ranch_update
    $box_ranch.update if $box_ranch
  end
end

#===============================================================================
# * Game_System
#===============================================================================

class Game_System
  alias box_ranch_initialize initialize
  def initialize
    box_ranch_initialize
    $box_ranch = BoxRanch.new
  end
end