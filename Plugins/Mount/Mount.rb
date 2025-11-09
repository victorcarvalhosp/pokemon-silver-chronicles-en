#===============================================================================================
# INSTALAÇÃO DO SISTEMA DE SURF
#===============================================================================================
# 1. Insira todos os gráficos de Surf na pasta definida em SURF_FOLDER.
# 2. Mova obrigatoriamente os arquivos padrão "boy_surf" e "girl_surf" para essa mesma pasta.
#
#-----------------------------------------------------------------------------------------------
# SURFS EXCLUSIVOS
#-----------------------------------------------------------------------------------------------
# Este sistema reconhece automaticamente:
# - O ID do personagem (character_ID), sendo 1 e 2 os padrões do Essentials.
# - A espécie e forma do Pokémon.
# - Versões Shiny e fêmea (inclusive combinadas).
# - Compatibilidade com Outfits do jogador.
#
#-----------------------------------------------------------------------------------------------
# EXEMPLOS DE NOMES DE ARQUIVOS
#-----------------------------------------------------------------------------------------------
# Exemplo 1:
#   2_SQUIRTLE_0
#   → "2" representa o character_ID
#   → "SQUIRTLE" é a espécie
#   → "0" indica a forma padrão
#
# Exemplo 2:
#   1_SQUIRTLE_fs0_7
#   → "1" representa o character_ID
#   → "SQUIRTLE" é a espécie
#   → "f" indica versão fêmea
#   → "s" indica versão Shiny
#   → "0" indica a forma padrão
#   → "7" representa a Outfit utilizada
#
#-----------------------------------------------------------------------------------------------
# NOTAS
#-----------------------------------------------------------------------------------------------
# - Por padrão, o character_ID 1 corresponde ao RED e o character_ID 2 à LEAF no Pokémon Essentials.
# - Certifique-se de manter a nomeação exatamente neste formato para garantir o reconhecimento.
#===============================================================================================

module Mount
  CHARACTER_FOLDER = "Graphics/Characters/"
  SURF_FOLDER = CHARACTER_FOLDER + "Surf Graphics/"

  module_function 
  def getSurfSprite
    pkmn = $player.get_pokemon_with_move(:SURF)
    return if !pkmn 
    species        = pkmn.species
    form        = pkmn.form
    shiny       = pkmn.shiny?
    female      = pkmn.female? 
    player_id   = $player.character_ID
    ret         = player_id == 0 ? "hero_female_surf" : "hero_male_surf"
    # LOCALIZA SPRITE PADRÃO
    if pbResolveBitmap(CHARACTER_FOLDER + "#{player_id}_#{species}_0")
      ret = "#{player_id}_#{species}_0"
    end
    # LOCALIZA SPRITE COM FORMAS DIFERENTES
    if form != 0 && pbResolveBitmap(SURF_FOLDER + "#{player_id}_#{species}_#{form}")
      ret = "#{player_id}_#{surf}_#{form}"
    end
    # VERIFICA SE HÁ A VERSÃO SHINY DEFINIDA
    if shiny && pbResolveBitmap(SURF_FOLDER + "#{player_id}_#{species}_s#{form}")
      ret = "#{player_id}_#{surf}_s#{form}"
    end
    # VERIFICA SE É FÊMEA E HÁ UM SPRITE COM FORMA DEFINIDA
    if female && shiny && pbResolveBitmap(SURF_FOLDER + "#{player_id}_#{species}_fs#{form}")
      ret = "#{player_id}_#{species}_fs#{form}"
    end
    # APÓS A LOCALIZAÇÃO COMPLETA, VERIFICA SE POSSUI UMA OUTFIT COMPATÍVEL
    if $player.outfit != 0 && pbResolveBitmap(CHARACTER_FOLDER + ret + "_#{$player.outfit}") 
      ret = ret + "_#{$player.outfit}"
    end
    # ret =  ret 
    Console.echo_li("Ret: #{ret}")

    return ret 
  end 
end

def pbGetPlayerCharset(charset, trainer = nil, force = false)
  trainer = $player if !trainer
  outfit = (trainer) ? trainer.outfit : 0
  return nil if !force && $game_player&.charsetData &&
                $game_player.charsetData[0] == trainer.character_ID &&
                $game_player.charsetData[1] == charset &&
                $game_player.charsetData[2] == outfit
  $game_player.charsetData = [trainer.character_ID, charset, outfit] if $game_player
  ret = charset
  if pbResolveBitmap("Graphics/Characters/" + ret + "_" + outfit.to_s)
    ret = ret + "_" + outfit.to_s
  end
  ret = Mount.getSurfSprite if $PokemonGlobal&.surfing
  return ret
end