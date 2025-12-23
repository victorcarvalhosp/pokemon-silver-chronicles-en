# Social Links - Phone Integration Guide

## Overview
This guide explains how the Social Links system integrates with the Phone feature, allowing players to call their contacts directly from Social Link profiles.

## How It Works

### 1. Automatic Name Matching
Phone integration works automatically by matching the Social Link's `:name` with phone contacts. No additional configuration needed!

```ruby
GameData::SocialLinkProfile.register({
    :id             => :JOEY,
    :name           => _INTL("Joey"),  # Flexible matching - works with or without trainer type
    :image          => "Joey",
    # ... other parameters ...
})
```

**Key Points:**
- For trainer contacts: Can use either just the name (e.g., "Joey") OR the full display name (e.g., "Youngster Joey")
- For NPC contacts: Use the exact name as registered in the phone (e.g., "Professor Oak", "Mother")
- Matching is flexible and intelligent - both formats work for trainers!
- If multiple contacts have the same name, the first match is used

### 2. Phone Contact Requirement
The phone integration only works if:
- The player has a phone contact whose name matches the Social Link's name
- The contact is visible in the phone (not hidden)

### 3. User Experience
When viewing a Social Link profile with phone integration:

**Visual Indicators:**
- A phone button icon appears on the right side of the profile screen
- Button hint text appears at the bottom: "USE: Phone Call" or "USE: Call"
- If both phone and instant messages are available, both hints are shown

**Making a Call:**
- Press the **USE button** (C key) to initiate a phone call
- The standard phone call system is used (same as calling from the Phone menu)
- All phone call logic applies: region checks, distance checks, random dialogue, etc.

### 4. Technical Details

**New Methods:**
- `profile.has_phone_contact?` - Returns true if a matching phone contact exists
- `profile.phone_contact` - Returns the phone contact data array or nil

**Name Matching Logic:**
- For trainers (8-element phone array): Matches either the trainer name alone OR "TrainerType TrainerName"
- For NPCs (4-element phone array): Matches the name directly
- Searches through all visible phone contacts and returns the first match
- Flexible matching means you can use "Joey" or "Youngster Joey" - both work!

**Button Layout:**
- If only phone: Button appears at default position (right side, y=152)
- If phone + instant messages: Phone button appears below IM button

**Input Mapping:**
- Phone calls use the USE button (C key by default)
- Instant Messages use the SPECIAL button (Z key by default)

### 5. Example Configurations

**Example 1: Trainer Contact (Youngster Joey)**
```ruby
# Phone registration
pbPhoneRegister(nil, :YOUNGSTER, "Joey")

# Social Link profile - can use either "Joey" or "Youngster Joey"
GameData::SocialLinkProfile.register({
    :id             => :JOEY,
    :name           => _INTL("Joey"),  # Both "Joey" and "Youngster Joey" work!
    :image          => "Joey",
    # ... other parameters ...
})
```

**Example 2: NPC Contact (Professor Oak)**
```ruby
# Phone registration
pbPhoneRegisterNPC(1, "Professor Oak", 1, true)

# Social Link profile - name must match "Professor Oak"
GameData::SocialLinkProfile.register({
    :id             => :PROFOAK,
    :name           => _INTL("Professor Oak"),
    :image          => "Oak",
    # ... other parameters ...
})
```

### 6. Automatic Sync Function

**pbAddSocialLinksFromPhone**

A convenient function to automatically add Social Links for all phone contacts:

```ruby
# Add Social Links for all matching phone contacts
pbAddSocialLinksFromPhone

# Silent version (no message)
pbAddSocialLinksFromPhone(silent: true)
```

**How it works:**
- Checks all visible phone contacts
- For each contact, searches for a matching Social Link profile by name
- Adds the Social Link if found and not already added
- Skips contacts that don't have matching profiles
- Returns the number of Social Links added

**Use cases:**
- Bulk import phone contacts as Social Links
- Sync after adding multiple phone contacts
- Event-triggered Social Link additions
- Debug/testing purposes

### 7. Phone Button Graphic
The system looks for `Graphics/UI/Social Links/phone_button.png`. If not found, it uses the instant message button graphic as a fallback.

**Recommended:** Create a custom phone button icon at:
`Graphics/UI/Social Links/phone_button.png`

### 8. Integration with Existing Systems

**Phone System:**
- Uses `pbCallTrainer(trainer_type, trainer_name)` function
- Respects all phone system rules (distance, region, availability)
- Uses the same phone dialogue system

**Instant Messages:**
- Both systems can coexist on the same profile
- Phone uses USE button (C key), IM uses SPECIAL button (Z key)
- Button hints adjust automatically

### 9. Troubleshooting

**Phone button doesn't appear:**
- Check that the Social Link name matches a phone contact
- For trainers, you can use either just the name (e.g., "Joey") or full name (e.g., "Youngster Joey")
- Verify the contact exists in the phone (`$PokemonGlobal.phoneNumbers`)
- Ensure the contact is visible (first element of phone array is `true`)

**Call doesn't work:**
- Verify the name matching is correct (check with `test_phone_integration(:PROFILE_ID)`)
- Check phone system requirements (region, distance, etc.)
- Ensure `pbCallTrainer` function is available

**Name matching issues:**
- For trainers: Either format works - "Joey" or "Youngster Joey"
- For NPCs: Use the exact name passed to `pbPhoneRegisterNPC`
- Test with `test_phone_integration(:PROFILE_ID)` to see the matching status

**Button positioning issues:**
- Check if custom layout settings are enabled in Social Link configuration
- Verify graphics files exist and are properly named

## Code Changes Summary

### Modified Files:
1. **001_Data.rb** - Added phone contact matching methods
2. **003_SocialUI.rb** - Added phone button UI and call functionality
3. **002_Configuration.rb** - Updated documentation and examples

### No Breaking Changes:
- Existing Social Links continue to work normally
- Phone system remains unchanged
- All features are automatic and backwards compatible
- No additional configuration required beyond matching names

