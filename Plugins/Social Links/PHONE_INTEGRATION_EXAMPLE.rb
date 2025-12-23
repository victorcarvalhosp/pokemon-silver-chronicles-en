#===============================================================================
# Phone Integration Example Script
# 
# This file contains example code for testing the Social Links + Phone integration.
# You can call these methods from debug console or events to test the feature.
#===============================================================================

# Example 1: Set up Joey as both a Social Link and Phone Contact
def setup_joey_example
  # First, add Joey to the phone
  # For a trainer contact with rematch capability:
  pbPhoneRegister(nil, :YOUNGSTER, "Joey")
  
  # Then add Joey as a Social Link
  # NOTE: The Social Link can use either "Joey" or "Youngster Joey" - both work!
  pbAddSocialLink(:JOEY)
  
  # Now when you view Joey's Social Link profile, you can call him!
  pbMessage(_INTL("Joey has been added to your phone and Social Links!"))
  pbMessage(_INTL("Open Social Links and view Joey's profile, then press USE (C key) to call him."))
end

# Example 2: Set up an NPC contact with Social Link
def setup_npc_example
  # For NPCs, use pbPhoneRegisterNPC
  # Parameters: (identifier, name, map_id, show_message)
  pbPhoneRegisterNPC(50, "Professor Oak", 1, true)
  
  # Then you would need a Social Link profile configured like:
  # GameData::SocialLinkProfile.register({
  #     :id             => :PROFOAK,
  #     :name           => _INTL("Professor Oak"),  # Must match phone contact name
  #     ...
  # })
  
  # pbAddSocialLink(:PROFOAK)
end

# Example 3: Test if a Social Link has phone integration
def test_phone_integration(profile_id)
  if !pbHasSocialLink?(profile_id)
    pbMessage(_INTL("You don't have this Social Link yet."))
    return
  end
  
  profile = pbPlayerSocialLinksSaved.links[profile_id]
  
  if profile.has_phone_contact?
    contact = profile.phone_contact
    pbMessage(_INTL("{1} is in your phone! You can call them from their profile.", profile.name))
    pbMessage(_INTL("Phone contact: {1}", contact[2]))
  else
    pbMessage(_INTL("{1} is not in your phone contacts.", profile.name))
    pbMessage(_INTL("Add a phone contact with the name '{1}' to enable calling.", profile.name))
  end
end

# Example 4: Automatically add Social Links from all phone contacts
def add_all_phone_social_links_example
  # This will check all phone contacts and add matching Social Links
  pbAddSocialLinksFromPhone
  
  # Silent version (no message shown):
  # pbAddSocialLinksFromPhone(silent: true)
end

# Example 5: Quick test setup (run this from debug console)
def quick_phone_social_test
  # Make sure player has pokegear
  $player.has_pokegear = true if !$player.has_pokegear
  
  # Set up Joey with both systems
  setup_joey_example
  
  # Open the Social Links menu
  pbSocialMedia
end

# Example 6: Bulk setup - Add multiple phone contacts then sync to Social Links
def bulk_phone_social_sync_example
  # Add several phone contacts
  pbPhoneRegister(nil, :YOUNGSTER, "Joey")
  pbPhoneRegisterNPC(1, "Professor Oak", 1, false)
  pbPhoneRegisterNPC(2, "Mother", 1, false)
  
  # Now automatically add all matching Social Links
  count = pbAddSocialLinksFromPhone
  
  pbMessage(_INTL("Phone sync complete! {1} Social Links added.", count))
end

#===============================================================================
# Debug Commands
# 
# You can add these to your debug menu or call from console:
#
# setup_joey_example                    - Sets up Joey with phone + social link
# test_phone_integration(:JOEY)         - Tests if Joey has phone integration
# pbAddSocialLinksFromPhone             - Syncs all phone contacts to Social Links
# add_all_phone_social_links_example    - Example of bulk sync
# bulk_phone_social_sync_example        - Add multiple contacts and sync
# quick_phone_social_test               - Complete test setup
#
# To test in-game:
# 1. Run: quick_phone_social_test
# 2. Navigate to Joey's profile in Social Links
# 3. Press USE button (C key) to call him
#
# To sync all phone contacts:
# 1. Run: pbAddSocialLinksFromPhone
# 2. All matching phone contacts will be added as Social Links
#===============================================================================

