#===============================================================================
# ■ Fly Animation by KleinStudio
# http://pokemonfangames.com
#===============================================================================
# A.I.R (Update for v20.1)
#V2.0
#===============================================================================
class Game_Character
  def setOpacity(value)
    @opacity = value
  end
end
#-------------------
if Show_Gen_4_Bird == false
def pbFlyAnimation(landing=true)
  if landing
    $game_player.turn_left
    pbSEPlay("flybird")
  end
	width  = Settings::SCREEN_WIDTH
	height = Settings::SCREEN_HEIGHT
  @flybird = Sprite.new
  @flybird.bitmap = RPG::Cache.picture("flybird")
  @flybird.ox = @flybird.bitmap.width/2
  @flybird.oy = @flybird.bitmap.height/2
  @flybird.x  = width + @flybird.bitmap.width
  @flybird.y  = height/4
  loop do
    pbUpdateSceneMap
    if @flybird.x > (width / 2 + 10)
      @flybird.x -= (width + @flybird.bitmap.width - width / 2).div BIRD_ANIMATION_TIME
      @flybird.y -= (height / 4 - height / 2).div BIRD_ANIMATION_TIME
    elsif @flybird.x <= (width / 2 + 10) && @flybird.x >= 0
      @flybird.x -= (width + @flybird.bitmap.width - width / 2).div BIRD_ANIMATION_TIME
      @flybird.y += (height / 4 - height / 2).div BIRD_ANIMATION_TIME
      $game_player.setOpacity(landing ? 0 : 255)
    else
      break
    end
    Graphics.update
  end
  @flybird.dispose
  @flybird = nil
end
else
  def pbFlyAnimation(landing=true)
    if landing
      $game_player.turn_left
      pbSEPlay("flybird")
    end
    width  = Settings::SCREEN_WIDTH
    height = Settings::SCREEN_HEIGHT
    @flybird = Sprite.new
    @flybird.bitmap = RPG::Cache.picture("flybird_gen4")
    @flybird.ox = @flybird.bitmap.width/2
    @flybird.oy = @flybird.bitmap.height/2
    @flybird.x  = width + @flybird.bitmap.width
    @flybird.y  = height/4
    loop do
      pbUpdateSceneMap
      if @flybird.x > (width / 2 + 10)
        @flybird.x -= (width + @flybird.bitmap.width - width / 2).div BIRD_ANIMATION_TIME
        @flybird.y -= (height / 4 - height / 2).div BIRD_ANIMATION_TIME
      elsif @flybird.x <= (width / 2 + 10) && @flybird.x >= 0
        @flybird.x -= (width + @flybird.bitmap.width - width / 2).div BIRD_ANIMATION_TIME
        @flybird.y += (height / 4 - height / 2).div BIRD_ANIMATION_TIME
        $game_player.setOpacity(landing ? 0 : 255)
      else
        break
      end
      Graphics.update
    end
    @flybird.dispose
    @flybird = nil
  end
end