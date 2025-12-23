#===============================================================================
# Social Link Profile registrations
#
# These are the Social Links for individual NPCs the player can interact with.
#
# PHONE INTEGRATION:
# Phone calling is automatically enabled for any Social Link whose :name matches
# a contact in the player's phone. The system will:
#   - Match the Social Link name with phone contacts
#   - Show a phone button and USE hint on the profile when a match is found
#   - Allow calling the contact by pressing USE button (C key)
#
# Name matching is flexible:
#   - For trainers: Matches either just the name (e.g., "Joey") OR the full display 
#     name with trainer type (e.g., "Youngster Joey")
#   - For NPCs: Matches the exact registered name (e.g., "Professor Oak", "Mother")
#
# Examples:
#   - Social Link "Joey" matches trainer phone contact (YOUNGSTER, "Joey")
#   - Social Link "Youngster Joey" also matches trainer phone contact (YOUNGSTER, "Joey")
#   - Social Link "Professor Oak" matches NPC phone contact "Professor Oak"
#
# If multiple contacts have the same name, the first match is used.
#===============================================================================
# Parameters:
#   - :id => Symbol - The ID of the Social Link 
#   - :name => String - The name of the NPC
#   - :image => String - The filename of the image used to represent the NPC's profile picture. 
#               File location: UI/Social Links/Profile Pictures
#   - :init_location => (Optional) String - The default location to show for the Social Link
#   - :init_status => (Optional) String - The default status message to show for the Social link
#   - :favorite_pokemon => (Optional) The default favorite Pokemon for the Social link. You have two options to set:
#                       - Set to a Symbol defining the species of Pokemon
#                       - Set to an array with the following structure:
#                         [Symbol of the species of Pokemon, gender (0 = male, 1 = female), form number, shiny? (true or false)]
#   - :im_contact_id => [Requires the Instant Messages plugin] (Optional) Symbol defining the Contact ID to associate with this Social Link
#   - :bond_max => (Optional) Integer - The max bond level of the NPC, which overrides BOND_LEVEL_MAX
#   - :bond_icon_coords => (Optional) Array - Set custom bond icon coordinates. Review the BOND_ICON_COORDS setting for instructions on how to set up.
#   - :moments_max => (Optional) Integer or Array of Integers - The max number of Moments you need to have with the NPC before it can increase your Bond, 
#                       which overrides MOMENTS_COUNT_MAX. If an integer, it will be the same max for all Bond levels. If an array of integers, the max will
#                       be different based on the current Bond level (which correlates to each index of the array).
#                       Examples: 5 => 5 is the max number of Moments needed to increase any Bond level.
#                                 [3, 3, 3, 4, 4, 5, 5, 6, 6, 6] => Needs 3 Moments to increase from
#                                 Bond 0 to 1, 1 to 2, or 2 to 3, 4 Moments for 3 to 4, or 4 to 5,
#                                 5 Moments for 5 to 6, or 6 to 7, and 6 Moments for 7 to 8, 8 to 9,
#                                 and 9 to 10.
#   - :bond_effects => (Optional) Hash defining bond effects gained at certain bond levels. Use the following structure:
#                           {
#                               Integer => [[:EFFECT_TYPE, :TYPE, rate]],
#                           }
#                               - Integer => The bond level needed to gain the effect
#                               - :EFFECT_TYPE => Set as either :EXP, :CatchRate, or :Shiny, depending on which effect you want
#                               - :TYPE => Symbol defining the type of Pokemon to get the effects
#                               - rate => Set as either a Float to multiply the EXP/CatchRate rate by, or Integer to add that number of retries for being a shiny.
#
#      NOTE: If multiple EXP rates, CatchRate rates, or shiny retries can be applied at once, either by the same Social Link or across all Social Links, 
#           only the highest rate/retry value will be applied. For dual type Pokemon, rates/retries do not stack between the two types; only the
#           highest rate/retry value between the two types will be used.
#           For example:
#               - If one Social Link provide a 1.3 EXP rate for Fire types, and a second Social Link provides a 1.5 EXP rate for Fire types, only the 
#                 1.5 EXP rate will apply, not 1.5 * 1.3.
#               - If you have active effects for Normal types to gain 1.3 EXP, and Flying types to gain 1.2 EXP, a Pidgey will only gain 1.3 EXP, not 1.3 * 1.2.
#               - If you have active effects for Normal types to have 3 extra shiny retries, and Flying types to have 1 extra shiny retry, a Pidgey will only 
#                 gain 3 extra shiny retries, not 3 + 1.
#
#
#   - :static_status_pool => (Optional) An Array of Strings. These are predefined status messages you can make appear for the
#                            Social Link using pbSetSocialLinkStatus
#   - :random_status_pool => (Optional) An Array of Arrays. These are predefined status messages you can make appear for the
#                            Social Link using pbSetSocialLinkStatusRandom. Each status message can have a minimum bond level
#                            in order to appear. For each subarray, use the following structure:
#                               [Status, MinBondLevel]
#                               - Status => String representing the status message
#                               - MinBondLevel => (Optional) Integer representing the minimum bond level needed for this status to appear.
#===============================================================================

GameData::SocialLinkProfile.register({
    :id             => :PROFOAK,
    :name		    => _INTL("Professor Oak"),
    :image		    => "Oak",
    :init_location  => _INTL("Pallet Town"),
    :init_status    => _INTL("It's a good day."),
    :favorite_pokemon => :PIKACHU,
    :im_contact_id  => :PROFOAK,
    :bond_effects   => {
                        1 => [[:CatchRate, :ELECTRIC, 1.2]],
                        4 => [[:EXP, :ELECTRIC, 1.1]],
                        9 => [[:Shiny, :ELECTRIC, 2]]
                    },
    :static_status_pool => [
                        _INTL("Hello World"),
                        _INTL("#TooManyCharmander"),
                        _INTL("#NotEnoughBulbasaur"),
                         ],
    :random_status_pool =>[
                        [_INTL("It's a great day.")],
                        [_INTL("It's a fine day."), 2],
                        [_INTL("It's an okay day."), 6],
                        [_INTL("It's an alright day."), 8]
                        ]
})

GameData::SocialLinkProfile.register({
    :id             => :JOEY,
    :name		    => _INTL("Joey"),  # Matches trainer name (works with or without "Youngster")
    :image		    => "Joey",
    :init_location  => _INTL("Viridian City"),
    :init_status    => _INTL("It's getting cold out. Maybe I should try wearing longer shorts?"),
    :favorite_pokemon => [:RATTATA, 0, 0, true],
    :bond_effects   => {
                        2 => [[:EXP, :NORMAL, 1.1], [:Shiny, :NORMAL, 1]],
                        5 => [[:CatchRate, :NORMAL, 1.4]],
                        7 => [[:Shiny, :NORMAL, 2]],
                        10 => [[:EXP, :NORMAL, 1.8], [:Shiny, :NORMAL, 5]]
                    }
})


GameData::SocialLinkProfile.register({
    :id             => :MOTHER,
    :name		    => _INTL("Mother"),
    :image		    => "Mother",
    :init_location  => _INTL("New Bark Town"),
    :init_status    => _INTL("Stay safe out there, sweetie!")
})

GameData::SocialLinkProfile.register({
    :id             => :BROCK,
    :name		    => _INTL("Brock"),
    :image		    => "Brock",
    :init_status    => _INTL("I've see a <b>lot</b> of Geodude around lately. It brings a tear to my eye."),
    :bond_max       => 3,
    :bond_icon_coords => [
                    [112, 154],
                    [138, 138],
                    [154, 112]
                    ]
})

GameData::SocialLinkProfile.register({
    :id             => :PROFELM,
    :name		    => _INTL("Professor Elm"),
    :image		    => "Elm",
    :init_location  => _INTL("New Bark Town"),
    :init_status    => _INTL("Research is going well today!")
})

GameData::SocialLinkProfile.register({
    :id             => :PROFIVY,
    :name		    => _INTL("Professor Ivy"),
    :image		    => "Ivy",
    :init_location  => _INTL("Valencia Island"),
    :init_status    => _INTL("The weather is beautiful here.")
})

GameData::SocialLinkProfile.register({
    :id             => :KRIS,
    :name		    => _INTL("Kris"),
    :image		    => "Kris",
    :init_location  => _INTL("New Bark Town"),
    :init_status    => _INTL("Ready for a new adventure!")
})

GameData::SocialLinkProfile.register({
    :id             => :YELLOW,
    :name		    => _INTL("Yellow"),
    :image		    => "Yellow",
    :init_location  => _INTL("Viridian City"),
    :init_status    => _INTL("Spending time with my Pokémon.")
})

GameData::SocialLinkProfile.register({
    :id             => :RED,
    :name		    => _INTL("Red"),
    :image		    => "Red",
    :init_location  => _INTL("Mt. Silver"),
    :init_status    => _INTL("...")
})

GameData::SocialLinkProfile.register({
    :id             => :WADE,
    :name		    => _INTL("Bug Catcher Wade"),
    :image		    => "Wade",
    :init_location  => _INTL("Route 31"),
    :init_status    => _INTL("Found some cool Bug Pokémon today!")
})

GameData::SocialLinkProfile.register({
    :id             => :LIZ,
    :name		    => _INTL("Picnicker Liz"),
    :image		    => "Liz",
    :init_location  => _INTL("Route 32"),
    :init_status    => _INTL("Perfect day for a picnic!")
})

GameData::SocialLinkProfile.register({
    :id             => :ANTHONY,
    :name		    => _INTL("Hiker Anthony"),
    :image		    => "Anthony",
    :init_location  => _INTL("Route 33"),
    :init_status    => _INTL("The mountain trails are calling me.")
})

GameData::SocialLinkProfile.register({
    :id             => :IAN,
    :name		    => _INTL("Youngster Ian"),
    :image		    => "Ian",
    :init_location  => _INTL("Route 34"),
    :init_status    => _INTL("Training hard every day!")
})

GameData::SocialLinkProfile.register({
    :id             => :IRWIN,
    :name		    => _INTL("Juggler Irwin"),
    :image		    => "Irwin",
    :init_location  => _INTL("Route 35"),
    :init_status    => _INTL("Practicing my juggling skills.")
})

GameData::SocialLinkProfile.register({
    :id             => :BEVERLY,
    :name		    => _INTL("Pokéfan Beverly"),
    :image		    => "Beverly",
    :init_location  => _INTL("Route 36"),
    :init_status    => _INTL("My Pokémon are so adorable today!")
})

GameData::SocialLinkProfile.register({
    :id             => :DANA,
    :name		    => _INTL("Lass Dana"),
    :image		    => "Dana",
    :init_location  => _INTL("Route 38"),
    :init_status    => _INTL("Enjoying the sunshine!")
})

GameData::SocialLinkProfile.register({
    :id             => :WILTON,
    :name		    => _INTL("Fisherman Wilton"),
    :image		    => "Wilton",
    :init_location  => _INTL("Route 44"),
    :init_status    => _INTL("The fish are biting today!")
})

GameData::SocialLinkProfile.register({
    :id             => :GAVEN,
    :name		    => _INTL("CoolTrainer Gaven"),
    :image		    => "Gaven",
    :init_location  => _INTL("Route 45"),
    :init_status    => _INTL("Always ready for a battle!")
})