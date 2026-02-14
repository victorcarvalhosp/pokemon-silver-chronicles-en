#===============================================================================
# Partner Trainer Card Scene
# Similar to Mr. Gela's Trainer Card Scene but customized for partner
#===============================================================================

# Switch that determines partner gender: ON = BOYFRIEND, OFF = GIRLFRIEND
PARTNER_GENDER_SWITCH = 141

# Variables for partner data
PARTNER_NAME_VAR_BOY = 77
PARTNER_NAME_VAR_GIRL = 76
PARTNER_LEVEL_VAR = 79
PARTNER_MOOD_VAR = 80
PARTNER_HEART_COUNT_VAR = 85
PARTNER_STARTER_TYPE_VAR = 88 # 0 = Fire, 1 = Water, 2 = Grass

# Common event to call when partner levels up
PARTNER_LEVEL_UP_COMMON_EVENT = 27

class PokemonPartnerTrainerCard_Scene
  # Instance variables for partner data
  attr_accessor :partner_level
  attr_accessor :heart_count
  attr_accessor :starter_type
  attr_accessor :mood
  # Waits x frames
  def wait(frames)
    frames.times do
      Graphics.update
    end
  end

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
    if @sprites["bg"]
      @sprites["bg"].ox -= 2
      @sprites["bg"].oy -= 2
    end
  end

  def pbStartScene
    @front = true
    @flip = false
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    # Initialize partner data from game variables (with defaults)
    @partner_level = $game_variables[PARTNER_LEVEL_VAR] || 1
    @heart_count = $game_variables[PARTNER_HEART_COUNT_VAR] || 0
    starter_type_val = $game_variables[PARTNER_STARTER_TYPE_VAR] || 0
    @starter_type = [:fire, :water, :grass][starter_type_val] || :fire
    @mood = $game_variables[PARTNER_MOOD_VAR] || 0
    addBackgroundPlane(@sprites, "bg", "Trainer Card/bg", @viewport)
    @sprites["card"] = IconSprite.new(128 * 2, 96 * 2, @viewport)
    # TODO: Set partner-specific card bitmap
    @sprites["card"].setBitmap("Graphics/UI/Partner Trainer Card/card_0")

    @sprites["card"].ox = @sprites["card"].bitmap.width / 2
    @sprites["card"].oy = @sprites["card"].bitmap.height / 2

    @sprites["bg"].zoom_x = 2
    @sprites["bg"].zoom_y = 2
    @sprites["bg"].ox += 6
    @sprites["bg"].oy -= 26
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)

    @sprites["overlay2"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["overlay2"].bitmap)

    @sprites["overlay"].x = 128 * 2
    @sprites["overlay"].y = 96 * 2
    @sprites["overlay"].ox = @sprites["overlay"].bitmap.width / 2
    @sprites["overlay"].oy = @sprites["overlay"].bitmap.height / 2

    @sprites["help_overlay"] = IconSprite.new(0, Graphics.height - 48, @viewport)
    @sprites["help_overlay"].setBitmap("Graphics/UI/PartnerTrainer Card/overlay_0")
    @sprites["help_overlay"].zoom_x = 2
    @sprites["help_overlay"].zoom_y = 2
    # Determine partner trainer type based on switch
    partner_trainer_type = $game_switches[PARTNER_GENDER_SWITCH] ? :BOYFRIEND : :GIRLFRIEND
    # Position trainer sprite on the left side of the card (10px down, 10px left from previous position)
    @sprites["trainer"] = IconSprite.new(90, 280, @viewport)
    @sprites["trainer"].setBitmap(GameData::TrainerType.front_sprite_filename(partner_trainer_type))
    @sprites["trainer"].zoom_x = 2
    @sprites["trainer"].zoom_y = 2
    @sprites["trainer"].ox = @sprites["trainer"].bitmap.width / 2
    @sprites["trainer"].oy = @sprites["trainer"].bitmap.height
    @tx = @sprites["trainer"].x
    @ty = @sprites["trainer"].y

    # Partner name sprite (above trainer)
    @sprites["partner_name"] = IconSprite.new(120, 180, @viewport)
    @sprites["partner_name"].zoom_x = 2
    @sprites["partner_name"].zoom_y = 2
    @sprites["partner_name"].visible = false  # Will be drawn as text on overlay

    # Partner level sprite (to the right of name)
    @sprites["partner_level"] = IconSprite.new(200, 180, @viewport)
    @sprites["partner_level"].zoom_x = 2
    @sprites["partner_level"].zoom_y = 2
    @sprites["partner_level"].visible = false  # Will be drawn as text on overlay

    # Heart count image (bottom)
    @sprites["heart_count"] = IconSprite.new(0, 0, @viewport)

    # Mood image (top right corner)
    @sprites["mood"] = IconSprite.new(0, 0, @viewport)

    # Pokemon team image
    @sprites["team"] = IconSprite.new(0, 0, @viewport)

    pbDrawTrainerCardFront
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def flip1
    # "Flip"
    7.times do
      @sprites["overlay"].zoom_y = 1.03
      @sprites["card"].zoom_y = 2.06
      @sprites["overlay"].zoom_x -= 0.1
      @sprites["trainer"].zoom_x -= 0.2
      @sprites["trainer"].x -= 12
      @sprites["card"].zoom_x -= 0.15
      pbUpdate
      wait(1)
    end
    pbUpdate
  end

  def flip2
    # UNDO "Flip"
    7.times do
      @sprites["overlay"].zoom_x += 0.1
      @sprites["trainer"].zoom_x += 0.2
      @sprites["trainer"].x += 12
      @sprites["card"].zoom_x += 0.15
      @sprites["overlay"].zoom_y = 1
      @sprites["card"].zoom_y = 1
      pbUpdate
      wait(1)
    end
    @sprites["overlay"].zoom_x = 1
    pbUpdate
  end

  def pbDrawTrainerCardFront
    flip1 if @flip == true
    @front = true
    @sprites["trainer"].visible = true
    # Show partner-specific images when showing front of card
    @sprites["team"].visible = true if @sprites["team"].bitmap
    @sprites["heart_count"].visible = true if @sprites["heart_count"].bitmap
    @sprites["mood"].visible = true if @sprites["mood"].bitmap
    # TODO: Set partner-specific card bitmap
    @sprites["card"].setBitmap("Graphics/UI/Partner Trainer Card/card_0")
    @overlay  = @sprites["overlay"].bitmap
    @overlay2 = @sprites["overlay2"].bitmap
    @overlay.clear
    @overlay2.clear
    base   = Color.new(72, 72, 72)
    shadow = Color.new(160, 160, 160)
    baseGold = Color.new(255, 198, 74)
    shadowGold = Color.new(123, 107, 74)
    # TODO: Partner-specific star/score system
    # if $partner.stars == 5
    #   base   = baseGold
    #   shadow = shadowGold
    # end
    
    # Get partner-specific data from game variables
    is_boy = $game_switches[PARTNER_GENDER_SWITCH]
    partner_name_var = is_boy ? PARTNER_NAME_VAR_BOY : PARTNER_NAME_VAR_GIRL
    partner_name = ($game_variables[partner_name_var] || "Partner").to_s
    # Use game variables for partner data
    partner_level = $game_variables[PARTNER_LEVEL_VAR] || 1
    heart_count = $game_variables[PARTNER_HEART_COUNT_VAR] || 0
    mood = $game_variables[PARTNER_MOOD_VAR] || 1
    mood = [[mood, 1].max, 5].min  # Clamp mood between 1 and 5
    starter_type_val = $game_variables[PARTNER_STARTER_TYPE_VAR] || 0
    starter_type = [:fire, :water, :grass][starter_type_val] || :fire
    
    # Update Pokemon team image (1px up, 14px right from previous position, then 1px left)
    is_boy = $game_switches[PARTNER_GENDER_SWITCH]
    team_gender = is_boy ? "boy" : "girl"
    team_path = sprintf("Graphics/UI/Partner Trainer Card/team_%s_%s_%d", team_gender, starter_type.to_s, partner_level)
    if pbResolveBitmap(team_path)
      @sprites["team"].setBitmap(team_path)
      @sprites["team"].x = 153
      @sprites["team"].y = 138
      @sprites["team"].visible = true
    else
      @sprites["team"].visible = false
    end
    
    # Update heart count image (2px up, 14px left from previous position, then 3px right, then 1px right)
    heart_count_path = sprintf("Graphics/UI/Partner Trainer Card/heartCount_%d", heart_count)
    if pbResolveBitmap(heart_count_path)
      @sprites["heart_count"].setBitmap(heart_count_path)
      @sprites["heart_count"].x = 128 * 2 - @sprites["heart_count"].bitmap.width + 200 + 50 - 14 + 3 + 1
      @sprites["heart_count"].y = Graphics.height - @sprites["heart_count"].bitmap.height - 20 - 20 + 10 - 2
      @sprites["heart_count"].visible = true
    else
      @sprites["heart_count"].visible = false
    end
    
    # Update mood image (top right corner) - gender-specific
    is_boy = $game_switches[PARTNER_GENDER_SWITCH]
    mood_gender = is_boy ? "boy" : "girl"
    mood_path = sprintf("Graphics/UI/Partner Trainer Card/mood_%s_%d", mood_gender, mood)
    if pbResolveBitmap(mood_path)
      @sprites["mood"].setBitmap(mood_path)
      # Account for zoom when positioning (zoom_x = 2, so displayed width is 2x bitmap width)
      displayed_width = @sprites["mood"].bitmap.width * @sprites["mood"].zoom_x
      displayed_height = @sprites["mood"].bitmap.height * @sprites["mood"].zoom_y
      @sprites["mood"].x = Graphics.width - displayed_width - 20
      @sprites["mood"].y = 20
      @sprites["mood"].visible = true
    else
      @sprites["mood"].visible = false
    end
    
    # Calculate level text position - to the right of the name
    # Get name width to position level text after it
    # Name and level positioned 2px down from previous position
    name_width = @overlay.text_size(partner_name.to_s).width
    level_text = _INTL("Lv.{1}", partner_level.to_i)
    level_x = 80 + name_width + 10
    
    textPositions = [
      # Partner name and level (above trainer sprite, left side)
      [partner_name.to_s, 80, 82, 0, base, shadow],
      [level_text, level_x, 82, 0, base, shadow]
    ]
    @sprites["overlay"].z += 10
    pbDrawTextPositions(@overlay, textPositions)
    textPositions = [
      [_INTL("Press the Action Button to flip the card."), 16, 70 + 280, 0, Color.new(216, 216, 216), Color.new(80, 80, 80)]
    ]
    @sprites["overlay2"].z += 20
    pbDrawTextPositions(@overlay2, textPositions)
    flip2 if @flip == true
  end

  def pbDrawTrainerCardBack
    pbUpdate
    @flip = true
    flip1
    @front = false
    @sprites["trainer"].visible = false
    # Hide partner-specific images when showing back of card
    @sprites["team"].visible = false
    @sprites["heart_count"].visible = false
    @sprites["mood"].visible = false
    # TODO: Set partner-specific back card bitmap
    @sprites["card"].setBitmap("Graphics/UI/Partner Trainer Card/card_0b")
    @overlay  = @sprites["overlay"].bitmap
    @overlay2 = @sprites["overlay2"].bitmap
    @overlay.clear
    @overlay2.clear
    base   = Color.new(72, 72, 72)
    shadow = Color.new(160, 160, 160)
    baseGold = Color.new(255, 198, 74)
    shadowGold = Color.new(123, 107, 74)
    # TODO: Partner-specific star/score system
    # if $partner.stars == 5
    #   base   = baseGold
    #   shadow = shadowGold
    # end
    # TODO: Partner-specific Hall of Fame data
    textPositions = [
      # TODO: Add partner-specific back card information
    ]
    @sprites["overlay"].z += 20
    pbDrawTextPositions(@overlay, textPositions)
    textPositions = [
      [_INTL("Press the Action Button to flip the card."), 16, 70 + 280, 0, Color.new(216, 216, 216), Color.new(80, 80, 80)]
    ]
    @sprites["overlay2"].z += 20
    pbDrawTextPositions(@overlay2, textPositions)
    # TODO: Draw partner-specific badges
    imagepos = []
    # TODO: Add partner badge drawing logic
    pbDrawImagePositions(@overlay, imagepos)
    flip2
  end

  def pbTrainerCard
    pbSEPlay("GUI trainer card open")
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::C)
        if @front == true
          pbSEPlay("GUI trainer card flip")
          pbDrawTrainerCardBack
          wait(3)
        else
          pbSEPlay("GUI trainer card flip")
          pbDrawTrainerCardFront if @front == false
          wait(3)
        end
      end
      if Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      end
    end
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

#===============================================================================
#
#===============================================================================
class PokemonPartnerTrainerCardScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbTrainerCard
    @scene.pbEndScene
  end
end

#===============================================================================
# Partner management functions - accessible from RPG Maker Scripts
#===============================================================================
def pbIncreasePartnerHearts(amount = 1)
  return if amount <= 0
  current_hearts = $game_variables[PARTNER_HEART_COUNT_VAR] || 0
  new_hearts = current_hearts + amount
  
  # Check if we need to level up
  while new_hearts >= 10
    # Level up
    current_level = $game_variables[PARTNER_LEVEL_VAR] || 1
    $game_variables[PARTNER_LEVEL_VAR] = current_level + 1
    new_hearts -= 10
    # Call common event when leveling up
    pbCommonEvent(PARTNER_LEVEL_UP_COMMON_EVENT) if PARTNER_LEVEL_UP_COMMON_EVENT > 0
  end
  
  $game_variables[PARTNER_HEART_COUNT_VAR] = new_hearts
end

def pbDecreasePartnerHearts(amount = 1)
  return if amount <= 0
  current_hearts = $game_variables[PARTNER_HEART_COUNT_VAR] || 0
  new_hearts = [current_hearts - amount, 0].max
  $game_variables[PARTNER_HEART_COUNT_VAR] = new_hearts
end

def pbGetPartnerLevel
  return $game_variables[PARTNER_LEVEL_VAR] || 1
end

def pbGetPartnerHeartCount
  return $game_variables[PARTNER_HEART_COUNT_VAR] || 0
end

def pbSetPartnerLevel(level)
  $game_variables[PARTNER_LEVEL_VAR] = [level, 1].max
   # Call common event when leveling up
   pbCommonEvent(PARTNER_LEVEL_UP_COMMON_EVENT) if PARTNER_LEVEL_UP_COMMON_EVENT > 0
end

def pbSetPartnerHeartCount(count)
  $game_variables[PARTNER_HEART_COUNT_VAR] = [count, 0].max
end


def pbSetPartnerMood(mood)
  $game_variables[PARTNER_MOOD_VAR] = [[mood, 0].max, 5].min
end

def pbIncreasePartnerMood(amount = 1)
  return if amount <= 0
  current_mood = $game_variables[PARTNER_MOOD_VAR] || 0
  new_mood = [[current_mood + amount, 0].max, 5].min
  $game_variables[PARTNER_MOOD_VAR] = new_mood
end

def pbDecreasePartnerMood(amount = 1)
  return if amount <= 0
  current_mood = $game_variables[PARTNER_MOOD_VAR] || 0
  new_mood = [[current_mood - amount, 0].max, 5].min
  $game_variables[PARTNER_MOOD_VAR] = new_mood
end
