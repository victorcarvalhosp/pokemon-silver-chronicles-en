def pbMaxRaidDenSpecial(order = 1)

    if order == 1
        boss = Pokemon.new(:KINGLER,55)
        boss.learn_move(:ROCKSLIDE)
        boss.learn_move(:LIQUIDATION)
        boss.learn_move(:KNOCKOFF)
        boss.learn_move(:XSCISSOR)
        boss.dynamax_lvl = 10
        boss.gmax_factor = true

        
        rules = { 
            :rank => 5, 
            :loot => [:RARECANDY], 
            :turns => 10, 
            :kocount => 3, 
            :size => 3,
            :weather => :Rain,
            :terrain => :None,
            :environ => :Sand,
            :hard => true,
            :autoscale => true,
            :simple => false,
            :setcapture => true,
            :catch_rate => 255
        }
        pkmn_options = { :gmax_factor => true,  :obtaintext => "a stormy Max Raid Den", :catch_rate => 255  }
    elsif order == 2
        boss = Pokemon.new(:PIKACHU,55)
        boss.learn_move(:THUNDER)
        boss.learn_move(:MEGAKICK)
        boss.learn_move(:DIG)
        boss.learn_move(:DETECT)
        boss.dynamax_lvl = 10
        boss.gmax_factor = true

        
        rules = { 
            :rank => 5, 
            :loot => [:THUNDERSTONE], 
            :turns => 10, 
            :kocount => 3, 
            :size => 3,
            :weather => :None,
            :terrain => :Electric,
            :environ => :None,
            :hard => true,
            :autoscale => true,
            :simple => false,
            :setcapture => true,
            :catch_rate => 255
        }
        pkmn_options = { :gmax_factor => true,  :obtaintext => "a stormy Max Raid Den", :catch_rate => 255  }
    elsif order == 3
        boss = Pokemon.new(:DREDNAW,55)
        boss.learn_move(:SHELLSMASH)
        boss.learn_move(:LIQUIDATION)
        boss.learn_move(:STONEEDGE)
        boss.learn_move(:EARTHQUAKE)
        boss.dynamax_lvl = 10
        boss.gmax_factor = true

        
        rules = { 
            :rank => 5, 
            :loot => [:WATERSTONE], 
            :turns => 10, 
            :kocount => 3, 
            :size => 3,
            :weather => :Rain,
            :terrain => :None,
            :environ => :Sand,
            :hard => true,
            :autoscale => true,
            :simple => false,
            :setcapture => true,
            :catch_rate => 255
        }
        pkmn_options = { :gmax_factor => true,  :obtaintext => "a stormy Max Raid Den", :catch_rate => 255  }
    elsif order == 4
        boss = Pokemon.new(:COALOSSAL,55)
        boss.learn_move(:ROCKBLAST)
        boss.learn_move(:INCINERATE)
        boss.learn_move(:DIG)
        boss.learn_move(:HEAVYSLAM)
        boss.dynamax_lvl = 10
        boss.gmax_factor = true

        
        rules = { 
            :rank => 5, 
            :loot => [:FIRESTONE], 
            :turns => 10, 
            :kocount => 3, 
            :size => 3,
            :weather => :Sun,
            :terrain => :None,
            :environ => :Sand,
            :hard => true,
            :autoscale => true,
            :simple => false,
            :setcapture => true,
            :catch_rate => 255
        }
        pkmn_options = { :gmax_factor => true,  :obtaintext => "a stormy Max Raid Den", :catch_rate => 255  }

    elsif order == 5
        boss = Pokemon.new(:EEVEE,55)
        boss.learn_move(:LASTRESORT)
        boss.learn_move(:BATONPASS)
        boss.learn_move(:PROTECT)
        boss.learn_move(:STOREDPOWER)
        boss.dynamax_lvl = 10
        boss.gmax_factor = true

        
        rules = { 
            :rank => 5, 
            :loot => [:WATERSTONE], 
            :turns => 10, 
            :kocount => 3, 
            :size => 3,
            :weather => :Sun,
            :terrain => :None,
            :environ => :None,
            :hard => true,
            :autoscale => true,
            :simple => false,
            :setcapture => true,
            :catch_rate => 255
        }
        pkmn_options = { :gmax_factor => true,  :obtaintext => "a stormy Max Raid Den", :catch_rate => 255  }

    elsif order == 6
        boss = Pokemon.new(:BUTTERFREE,55)
        boss.learn_move(:QUIVERDANCE)
        boss.learn_move(:BUGBUZZ)
        boss.learn_move(:SLEEPPOWDER)
        boss.learn_move(:CONFUSION)
        boss.dynamax_lvl = 10
        boss.gmax_factor = true

        
        rules = { 
            :rank => 5, 
            :loot => [:LEAFSTONE], 
            :turns => 10, 
            :kocount => 3, 
            :size => 3,
            :weather => :Sun,
            :terrain => :None,
            :environ => :None,
            :hard => true,
            :autoscale => true,
            :simple => false,
            :setcapture => true,
            :catch_rate => 255
        }
        pkmn_options = { :gmax_factor => true,  :obtaintext => "a stormy Max Raid Den", :catch_rate => 255  }

    elsif order == 7
        boss = Pokemon.new(:GENGAR,55)
        boss.learn_move(:WILLOWISP)
        boss.learn_move(:DISABLE)
        boss.learn_move(:HEX)
        boss.learn_move(:SLUDGEWAVE)
        boss.dynamax_lvl = 10
        boss.gmax_factor = true

        
        rules = { 
            :rank => 5, 
            :loot => [:MOONSTONE], 
            :turns => 10, 
            :kocount => 3, 
            :size => 3,
            :weather => :Fog,
            :terrain => :Misty,
            :environ => :Graveyard,
            :hard => true,
            :autoscale => true,
            :simple => false,
            :setcapture => true,
            :catch_rate => 255
        }
        pkmn_options = { :gmax_factor => true,  :obtaintext => "a stormy Max Raid Den", :catch_rate => 255  }

    elsif order == 8
        boss = Pokemon.new(:MACHAMP,55)
        boss.learn_move(:CLOSECOMBAT)
        boss.learn_move(:FACADE)
        boss.learn_move(:KNOCKOFF)
        boss.learn_move(:BULLETPUNCH)
        boss.dynamax_lvl = 10
        boss.gmax_factor = true

        
        rules = { 
            :rank => 5, 
            :loot => [:SUNSTONE], 
            :turns => 10, 
            :kocount => 3, 
            :size => 3,
            :weather => :None,
            :terrain => :None,
            :environ => :None,
            :hard => true,
            :autoscale => true,
            :simple => false,
            :setcapture => true,
            :catch_rate => 255
        }
        pkmn_options = { :gmax_factor => true,  :obtaintext => "a stormy Max Raid Den", :catch_rate => 255  }

    else 
        # Todo update this
        boss = Pokemon.new(:PIKACHU,1)
        boss.learn_move(:THUNDER)
        boss.learn_move(:SURF)
        boss.learn_move(:DRAGON_DANCE)
        boss.learn_move(:DYNAMICPUNCH)
        boss.dynamax_lvl = 10
        boss.gmax_factor = true

        
        rules = { 
            :rank => 4, 
            :loot => [:RARECANDY], 
            :turns => 15, 
            :kocount => 5, 
            :size => 4,
            :weather => :Sunny,
            :terrain => :Grassy,
            :environ => :Cave,
            :hard => false,
            :autoscale => true,
            :simple => false,
            :setcapture => true
        }
    end 
   return pbMaxRaidDen(
      boss, 
      rules,
      pkmn_options
    ) 
end