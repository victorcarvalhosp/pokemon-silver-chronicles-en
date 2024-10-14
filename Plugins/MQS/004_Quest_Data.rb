module QuestModule
  
  # You don't actually need to add any information, but the respective fields in the UI will be blank or "???"
  # I included this here mostly as an example of what not to do, but also to show it's a thing that exists
  Quest0 = {
  
  }
  
  # Here's the simplest example of a single-stage quest with everything specified
  # Quest1 = {
  #   :ID => "1",
  #   :Name => "Introductions",
  #   :QuestGiver => "Little Boy",
  #   :Stage1 => "Look for clues.",
  #   :Location1 => "Lappet Town",
  #   :QuestDescription => "Some wild Pokémon stole a little boy's favourite toy. Find those troublemakers and help him get it back.",
  #   :RewardString => "Something shiny!"
  # }

  # Here's an extension of the above that includes multiple stages
  MysteryEgg = {
    :ID => "1",
    :Name => "The journey begins",
    :QuestGiver => "Professor Elm",
    :Stage1 => "Get package with Mr. Pokémon.",
    :Stage2 => "Return Mystery Egg.",
    :Location1 => "Past Cherrygrove City",
    :Location2 => "New Bark Town",
    :QuestDescription => "Professor Elm asked you to get something with Mr. Pokémon for him. It's probably an Egg.",
  }

  # @todo: Still need to add code to complete it in the game
  JohtoPokedex = {
    :ID => "2",
    :Name => "Gotta catch ‘em all!",
    :QuestGiver => "Professor Oak",
    :Stage1 => "Complete the Johto Pokédex.",
    :Stage2 => "Register at least 6 Pokémon.",
    :Stage3 => "Register at least 20 Pokémon.",
    :Stage4 => "Register at least 50 Pokémon.",
    :Location1 => "nil",
    :Location2 => "Route 31",
    :QuestDescription => "Go meet many kinds of Pokémon and complete that Pokédex!",
  }

  JohtoGymChallenge = {
    :ID => "3",
    :Name => "Pokémon Gym challenge",
    :QuestGiver => "Professor Elm",
    :Stage1 => "Challenge Violet City's Gym.",
    :Stage2 => "Challenge Azalea Town's Gym.",
    :Stage3 => "Challenge Goldenrod City's Gym.",
    :Stage4 => "Challenge Ecruteak City's Gym.",
    :Stage5 => "Challenge the next Gym.",
    :Stage6 => "Challenge Blackthorn City's Gym.",
    :Location1 => "Violet City",
    :Location2 => "Azalea Town",
    :Location3 => "Goldenrod City",
    :Location4 => "Ecruteak City",
    :Location5 => "Cianwood, Olivine or Mahogany Town",
    :Location6 => "Blackthorn City",
    :QuestDescription => "Collect all 8 Gym Badges in Johto. If you manage to defeat all the Gym Leaders, you'll eventually challenge the Pokémon League Champion!",
  }

  StudentInDarkCave = {
    :ID => "4",
    :Name => "Playing in a Dark Cave...",
    :QuestGiver => "Teacher Earl",
    :Stage1 => "Search for the missing student.",
    :Stage2 => "Go back to Violet School.",
    :Location1 => "Dark Cave",
    :Location2 => "Violet City",
    :QuestDescription => "A student lef for recess and didn't return yet! He was saying something about playing in a Dark Cave...",
  }

  SproutTower = {
    :ID => "4",
    :Name => "Sprout Tower challenge",
    :QuestGiver => "nil",
    :Stage1 => "Train in the Sprout Tower.",
    :Location1 => "Violet City",
    :QuestDescription => "Facing Falkner must be very difficult for you, better train in the Sprout Tower before.",
  }

  TogepiEgg = {
    :ID => "5",
    :Name => "Caring for the Mystery Egg",
    :QuestGiver => "Professor Elm",
    :Stage1 => "Get Egg with the assistant.",
    :Stage2 => "Hatch the egg.",
    :Location1 => "Violet City Poké Center",
    :Location2 => "???",
    :QuestDescription => "Professor Elm wants you to take care of an Egg. It seems that a Pokémon will hatch from it only when you keep it in your party of Pokémon.",
  }

  BellsproutTrade = {
    :ID => "6",
    :Name => "Rocky Trade",
    :QuestGiver => "Youngster Joey",
    :Stage1 => "Trade Pokémon.",
    :Location1 => "Violet City",
    :QuestDescription => "This youngster in Violet City wants to trade a Bellsprout for his Onix. Do you think it's a good trade?",
  }

  
  RuinsOfAlphPuzzleOne = {
    :ID => "7",
    :Name => "Mysterious Ruins",
    :QuestGiver => "nil",
    :Stage1 => "Check the Ruins Misteries.",
    :Location1 => "Ruins of Alph",
    :QuestDescription => "There are odd patterns drawn on the walls of the ruins. They must be the keys for unraveling it's misteries.",
  }

  SchoolKidPhanpy = {
    :ID => "8",
    :Name => "Phanpy's fan",
    :QuestGiver => "School Kid Henry",
    :Stage1 => "Catch a Phanpy.",
    :Location1 => "Route 46",
    :RewardString => "Berries!",
    :QuestDescription => "This kid near Route 46 really wants to see a Phanpy. If you can help with that, he's happy to thank you with some berries as a thank-you gift.",
  }

  TCGInitiation = {
    :ID => "9",
    :Name => "Pokémon Cards",
    :QuestGiver => "TCG Fan Jack",
    :Stage1 => "Open the Booster Pack.",
    :Stage2 => "Win the TCG duel.",
    :Location1 => "Violet City Mart",
    :Location2 => "Violet City Mart",
    :RewardString => "A nice Pokémon Card",
    :QuestDescription => "This guy gave you a nice binder and a booster pack of Pokémon cards. He's really excited to see what you got! Open the pack and show him your new cards and learn how to play Pokémon TCG.",
  }

  TCGLeague = {
    :ID => "10",
    :Name => "Pokémon Card Clubs Challenge",
    :QuestGiver => "TCG Fan Jack",
    :Stage1 => "Defeat the Grass Club.",
    :Stage2 => "Defeat the Fighting Club.",
    :Stage3 => "Defeat the Rock Club.",
    :Stage4 => "Defeat the Water Club.",
    :Stage5 => "Defeat the Lightning Club.",
    :Stage6 => "Defeat the Psychic Club.",
    :Stage7 => "Defeat the Fire Club.",
    :Stage8 => "Defeat the Science Club.",
    :Location1 => "??",
    :Location2 => "??",
    :Location3 => "??",
    :Location4 => "??",
    :Location5 => "??",
    :Location6 => "??",
    :Location7 => "??",
    :Location8 => "??",
    :QuestDescription => "Defeat all 8 Card Clubs in Johto. If you manage to defeat all the Club Masters, you may inherit the Legendary Pokémon Cards!",
  }

  SlowpokeWell = {
    :ID => "11",
    :Name => "Slowpoke Rescue",
    :QuestGiver => "Kurt",
    :Stage1 => "Check the Slowpoke Well.",
    :Location1 => "Slowpoke Well",
    :QuestDescription => "Team Rocket is cutting off SlowpokeTails for sale. Help Kurt to stop them!",
  }

  FarfetchRescue = {
    :ID => "12",
    :Name => "Lazy Farfetch'd",
    :QuestGiver => "Charcoal Maker",
    :Stage1 => "Find the Farfetch'd.",
    :Location1 => "Ilex Forest",
    :QuestDescription => "One of the FARFETCH'D that cut trees for charcoal took off in the forest. Bring it back to the Charcoal Maker Apprentice.",
  }

  MaizieTeddiursa = {
    :ID => "13",
    :Name => "Cute Teddiursa",
    :QuestGiver => "Maizie",
    :Stage1 => "Catch a Teddiursa.",
    :Location1 => "Azalea Town",
    :QuestDescription => "Kurt's grand daughter wants a Teddiursa, can you catch one and bring it to her?",
  }

  WildPokemonInGoldenrod = {
    :ID => "14",
    :Name => "Wild Pokémon in Goldenrod",
    :Stage1 => "Catch the thief Pokémon.",
    :Location1 => "Goldenrod City",
    :QuestDescription => "This Pokémon is stealing items in Goldenrod City, can you make it stop?",
  }

  LetterDeliver = {
    :ID => "15",
    :Name => "Letter Delivery",
    :QuestGiver => "Webster",
    :Stage1 => "Get the letter.",
    :Location1 => "Goldenrod City Gate",
    :Stage2 => "Deliver the letter.",
    :Location2 => "Route 31",
    :QuestDescription => "This guy received a letter from a friend. Now he's asking for you to deliver the reply he wrote to his friend.",
  }

  BurnedTower = {
    :ID => "16",
    :Name => "Burned Tower",
    :Stage1 => "Explore the Burned Tower.",
    :Location1 => "Ecruteak City",
    :QuestDescription => "Morty, the Gym Leader, has gone to the Burned Tower. Go there to investigate what's happening.",
  }

  KimonoGirlsEcruteak = {
    :ID => "17",
    :Name => "Kimono Girls power",
    :Stage1 => "Defeat the 5 Kimono Girls.",
    :Location1 => "Ecruteak City - Dance Theater",
    :QuestGiver => "Hiroshi",
    :QuestDescription => "Not only are the Kimono Girls great dancers, they're also skilled at Pokémon. If you win against them, you'll receive a gift.",
  }

  OlivineLighthouse = {
    :ID => "18",
    :Name => "Lighthouse is turned off?",
    :Stage1 => "Go to the Lighthouse.",
    :Location1 => "Olivine City",
    :Stage2 => "Get some medicines to Amphy.",
    :Location2 => "Cianwood City",
    :Stage3 => "Deliver the medicines to Amphy.",
    :Location3 => "Olivine City - Lighthouse",
    :QuestDescription => "Olivine City Gym Leader isn't in the Gym, she is taking care of a sick Pokémon at the Lighthouse.",
  }

  MantykeTrade = {
    :ID => "19",
    :Name => "Billy Trade",
    :QuestGiver => "Fisherman Richard",
    :Stage1 => "Trade Pokémon.",
    :Location1 => "Olivine City",
    :QuestDescription => "This fisherman in Olivine City wants to trade a Krabby for his Mantyke. Do you think it's a good trade?",
  }

  TeamRockerGoldenrod = {
    :ID => "20",
    :Name => "Team Rocket is back?!",
    :QuestGiver => "Prof. Elm",
    :Stage1 => "Investigate the Radio Tower.",
    :Location1 => "Goldenrod City",
    :Stage2 => "Investigate the Underground Warehouse.",
    :Location2 => "Goldenrod City",
    :Stage3 => "Go to the transmission room.",
    :Location3 => "Radio Tower 5F",
    :QuestDescription => "Something weird is happening with the radio broadcasts. Maybe Team Rocket has returned. Do you know anything about it?",
  }

  MrMimeTrade = {
    :ID => "21",
    :Name => "Maria Trade",
    :QuestGiver => "Schoolgirl Maria",
    :Stage1 => "Trade Pokémon.",
    :Location1 => "Blackthorn City",
    :QuestDescription => "This schoolgirl in Blackthorn City wants to trade a Dratini for her Mr. Mime. Do you think it's a good trade?",
  }

  ArcheologyIsCool = {
    :ID => "22",
    :Name => "The Enigmatic Unown",
    :QuestGiver => "Researcher Albright",
    :Stage1 => "Catch an Unown.",
    :Location1 => "Ruins of Alph",
    :RewardString => "Thunder Stone",
    :QuestDescription => "Catch and bring an Unown to the Leader Researcher Albright in the Ruins of Alph to help with his research.",
  }

  LugiaTeamRocket = {
    :ID => "23",
    :Name => "Pokémon Mistery",
    :QuestGiver => "Kimono Girl Kuni",
    :Stage1 => "Help Kuni to recover the Tidal Bell",
    :Location1 => "Whirl Islands",
    :QuestDescription => "The Tidal Bell was stolen by Team Rocket, now Kimono Girl Kuni needs your help to get it back.",
  }


  JohtoPokemonLeague = {
    :ID => "24",
    :Name => "Johto Pokémon League!",
    :QuestGiver => "Prof. Elm",
    :Stage1 => "Battle against Elite Four.",
    :Location1 => "Indigo Plateau",
    :QuestDescription => "The Indigo League and Johto League share a single group of Elite Four and Champion; eight Badges from either region will allow a Trainer to battle the Elite Four at Kanto's Indigo Plateau. Now this time has come for you!",
  }

  WorldChampionshipTraining = {
    :ID => "25",
    :Name => "Train for the World Cup",
    :QuestGiver => "Prof. Elm",
    :Stage1 => "Re-match against Johto Gym Leaders",
    :Stage2 => "Re-match against Johto Gym Leaders 1/8",
    :Stage3 => "Re-match against Johto Gym Leaders 2/8",
    :Stage4 => "Re-match against Johto Gym Leaders 3/8",
    :Stage5 => "Re-match against Johto Gym Leaders 4/8",
    :Stage6 => "Re-match against Johto Gym Leaders 5/8",
    :Stage7 => "Re-match against Johto Gym Leaders 6/8",
    :Stage8 => "Re-match against Johto Gym Leaders 7/8",
    :Stage9 => "Re-match against Johto Gym Leaders 8/8",
    :QuestDescription => "Now that you are the new Champion, a lot of people will be looking for a rematch! This includes the Gym Leaders... They are allowed to use their full-power this time, so be prepared.",
  }

  SSAqua = {
    :ID => "26",
    :Name => "S. S. Aqua trip",
    :QuestGiver => "S. S. Aqua Captain",
    :Stage1 => "Battle against all S. S. Aqua Trainers",
    :Location1 => "S. S. Aqua",
    :QuestDescription => "Most passengers are  Trainers and they're all itching to battle in their cabins. If you defeat all of them, please let the Captain know.",
  }

  HotelCheckIn = {
    :ID => "27",
    :Name => "Grand Hotel Check-in",
    :Stage1 => "Battle against all S. S. Aqua trainers",
    :Location1 => "Colosseum Town",
    :QuestDescription => "Your battle will be just tomorrow, try to get some rest and build your strength for what's to come.",
  }

  FirstWorldCupBattle = {
    :ID => "28",
    :Name => "First Pokémon World Cup Match!",
    :Stage1 => "Fist World Cup Match!",
    :Stage3 => "Knockout phase begins!",
    :Stage3 => "Quarter-finals phase begins!",
    :Location1 => "Colosseum Town",
    :QuestDescription => "That's it, the World Cup started! Go to the Stadium to participate in your first match, that will be against Caitlin, from Unova!",
  }

  SecondWorldCupBattle = {
    :ID => "29",
    :Name => "Second Pokémon World Cup Match!",
    :Stage1 => "Get some rest in the Grand Hotel.",
    :Stage2 => "Second World Cup Match!",
    :Location1 => "Colosseum Town",
    :QuestDescription => "That's it, the World Cup started! Go to the Stadium to participate in your second match, that will be against Nessa, from Galar!",
  }

  ThirdWorldCupBattle = {
    :ID => "30",
    :Name => "Third Pokémon World Cup Match!",
    :Stage1 => "Get some rest in the Grand Hotel.",
    :Stage2 => "Third World Cup Match!",
    :Location1 => "Colosseum Town",
    :QuestDescription => "It's time for the last Match in the Group phase! This time you'll face Paul, from Sinnoh!",
  }

  RoundOf16Battle = {
    :ID => "31",
    :Name => "World Cup Round of 16!",
    :Stage1 => "Go to the Stadium.",
    :Location1 => "Colosseum Town",
    :QuestDescription => "It's time for the Round of 16! Go to the Stadium to see the draw and see who you'll face!",
  }

  RoundOf8Battle = {
    :ID => "31",
    :Name => "World Cup Round of 8!",
    :Stage1 => "Go to the Stadium.",
    :Location1 => "Colosseum Town",
    :QuestDescription => "You've made it to the Round of 8! Your next battle will be against your Rival, so be ready!",
  }

  
  # Here's an extension of the above that includes multiple stages
  # Quest2 = {
  #   :ID => "2",
  #   :Name => "Introductions",
  #   :QuestGiver => "Little Boy",
  #   :Stage1 => "Look for clues.",
  #   :Stage2 => "Follow the trail.",
  #   :Stage3 => "Catch the troublemakers!",
  #   :Location1 => "Lappet Town",
  #   :Location2 => "Viridian Forest",
  #   :Location3 => "Route 3",
	# :StageLabel1 => "1",
	# :StageLabel2 => "2",
  #   :QuestDescription => "Some wild Pokémon stole a little boy's favourite toy. Find those troublemakers and help him get it back.",
  #   :RewardString => "Something shiny!"
  # }
  
  # Here's an example of a quest with lots of stages that also doesn't have a stage location defined for every stage
  Quest3 = {
    :ID => "3",
    :Name => "Last-minute chores",
    :QuestGiver => "Grandma",
    :Stage1 => "A",
    :Stage2 => "B",
    :Stage3 => "C",
    :Stage4 => "D",
    :Stage5 => "E",
    :Stage6 => "F",
    :Stage7 => "G",
    :Stage8 => "H",
    :Stage9 => "I",
    :Stage10 => "J",
    :Stage11 => "K",
    :Stage12 => "L",
    :Location1 => "nil",
    :Location2 => "nil",
    :Location3 => "Dewford Town",
    :QuestDescription => "Isn't the alphabet longer than this?",
    :RewardString => "Chicken soup!"
  }
  
  # Here's an example of not defining the quest giver and reward text
  Quest4 = {
    :ID => "4",
    :Name => "A new beginning",
    :QuestGiver => "nil",
    :Stage1 => "Turning over a new leaf... literally!",
    :Stage2 => "Help your neighbours.",
    :Location1 => "Milky Way",
    :Location2 => "nil",
    :QuestDescription => "You crash landed on an alien planet. There are other humans here and they look hungry...",
    :RewardString => "nil"
  }
  
  # Other random examples you can look at if you want to fill out the UI and check out the page scrolling
  Quest5 = {
    :ID => "5",
    :Name => "All of my friends",
    :QuestGiver => "Barry",
    :Stage1 => "Meet your friends near Acuity Lake.",
    :QuestDescription => "Barry told me that he saw something cool at Acuity Lake and that I should go see. I hope it's not another trick.",
    :RewardString => "You win nothing for giving in to peer pressure."
  }
  
  Quest6 = {
    :ID => "6",
    :Name => "The journey begins",
    :QuestGiver => "Professor Oak",
    :Stage1 => "Deliver the parcel to the Pokémon Mart in Viridian City.",
    :Stage2 => "Return to the Professor.",
    :Location1 => "Viridian City",
    :Location2 => "nil",
    :QuestDescription => "The Professor has entrusted me with an important delivery for the Viridian City Pokémon Mart. This is my first task, best not mess it up!",
    :RewardString => "nil"
  }
  
  Quest7 = {
    :ID => "7",
    :Name => "Close encounters of the... first kind?",
    :QuestGiver => "nil",
    :Stage1 => "Make contact with the strange creatures.",
    :Location1 => "Rock Tunnel",
    :QuestDescription => "A sudden burst of light, and then...! What are you?",
    :RewardString => "A possible probing."
  }
  
  Quest8 = {
    :ID => "8",
    :Name => "These boots were made for walking",
    :QuestGiver => "Musician #1",
    :Stage1 => "Listen to the musician's, uhh, music.",
    :Stage2 => "Find the source of the power outage.",
    :Location1 => "nil",
    :Location2 => "Celadon City Sewers",
    :QuestDescription => "A musician was feeling down because he thinks no one likes his music. I should help him drum up some business."
  }
  
  Quest9 = {
    :ID => "9",
    :Name => "Got any grapes?",
    :QuestGiver => "Duck",
    :Stage1 => "Listen to The Duck Song.",
    :Stage2 => "Try not to sing it all day.",
    :Location1 => "YouTube",
    :QuestDescription => "Let's try to revive old memes by listening to this funny song about a duck wanting grapes.",
    :RewardString => "A loss of braincells. Hurray!"
  }
  
  Quest10 = {
    :ID => "10",
    :Name => "Singing in the rain",
    :QuestGiver => "Some old dude",
    :Stage1 => "I've run out of things to write.",
    :Stage2 => "If you're reading this, I hope you have a great day!",
    :Location1 => "Somewhere prone to rain?",
    :QuestDescription => "Whatever you want it to be.",
    :RewardString => "Wet clothes."
  }
  
  Quest11 = {
    :ID => "11",
    :Name => "When is this list going to end?",
    :QuestGiver => "Me",
    :Stage1 => "When IS this list going to end?",
    :Stage2 => "123",
    :Stage3 => "456",
    :Stage4 => "789",
    :QuestDescription => "I'm losing my sanity.",
    :RewardString => "nil"
  }
  
  Quest12 = {
    :ID => "12",
    :Name => "The laaast melon",
    :QuestGiver => "Some stupid dodo",
    :Stage1 => "Fight for the last of the food.",
    :Stage2 => "Don't die.",
    :Location1 => "A volcano/cliff thing?",
    :Location2 => "Good advice for life.",
    :QuestDescription => "Tea and biscuits, anyone?",
    :RewardString => "Food, glorious food!"
  }

end
