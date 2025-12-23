# Phone to Social Links Sync Function

## Function: pbAddSocialLinksFromPhone

### Description
Automatically adds Social Links for all phone contacts that have matching Social Link profiles configured.

### Syntax
```ruby
pbAddSocialLinksFromPhone(silent: false)
```

### Parameters
- `silent` (optional, default: false) - If true, suppresses the result message

### Returns
- Integer - The number of Social Links that were added

### How It Works

1. **Scans Phone Contacts**: Iterates through all visible phone contacts in `$PokemonGlobal.phoneNumbers`

2. **Name Matching**:
   - For trainers: Matches either the trainer name alone OR "TrainerType TrainerName"
   - For NPCs: Matches the exact registered name

3. **Profile Search**: Searches through all registered Social Link profiles to find matches

4. **Smart Adding**: 
   - Only adds Social Links that aren't already added
   - Skips phone contacts that don't have matching profiles
   - Silently adds each matching profile

5. **Result Message**: Shows a summary of how many Social Links were added (unless silent mode)

### Usage Examples

#### Basic Usage
```ruby
# Add all matching Social Links with confirmation message
pbAddSocialLinksFromPhone
```

#### Silent Mode
```ruby
# Add all matching Social Links without showing a message
pbAddSocialLinksFromPhone(silent: true)
```

#### With Return Value
```ruby
# Check how many were added
count = pbAddSocialLinksFromPhone
if count > 0
  pbMessage(_INTL("Successfully synced {1} contacts!", count))
end
```

#### Event Script Usage
```ruby
# In an event after giving the player the Pokégear
pbMessage(_INTL("You received the Pokégear!"))
$player.has_pokegear = true

# Automatically sync any pre-registered phone contacts
pbAddSocialLinksFromPhone(silent: true)
```

#### Bulk Registration
```ruby
# Register multiple phone contacts
pbPhoneRegister(nil, :YOUNGSTER, "Joey")
pbPhoneRegister(nil, :LASS, "Emma")
pbPhoneRegisterNPC(1, "Professor Oak", 1, false)
pbPhoneRegisterNPC(2, "Mother", 1, false)

# Then sync them all at once
count = pbAddSocialLinksFromPhone
pbMessage(_INTL("Added {1} friends to Social Links!", count))
```

### Requirements

For this function to work:
1. Social Link profiles must be registered in `GameData::SocialLinkProfile`
2. The profile's `:name` must match the phone contact name
3. Phone contacts must be visible (first element = true)

### Name Matching Rules

**For Trainers:**
- Phone contact: `(YOUNGSTER, "Joey")`
- Matches Social Link with name: `"Joey"` OR `"Youngster Joey"`

**For NPCs:**
- Phone contact: `"Professor Oak"`
- Matches Social Link with name: `"Professor Oak"`

### Messages Shown

**No matches found:**
```
"No new Social Links were added from your phone contacts."
```

**One match found:**
```
"Added [Name] to your Social Links!"
```

**Multiple matches found:**
```
"Added [X] Social Links from your phone contacts!"
```

### Common Use Cases

1. **Initial Pokégear Setup**: Sync contacts when player first gets the Pokégear
2. **Story Events**: Add Social Links after story events that register phone contacts
3. **Batch Processing**: Register multiple contacts then sync all at once
4. **Debug/Testing**: Quickly populate Social Links for testing
5. **Save File Migration**: Update old saves with new Social Link system

### Technical Details

**Performance:**
- Iterates through all phone contacts once
- Searches Social Link profiles for each contact
- O(n*m) complexity where n = phone contacts, m = Social Link profiles
- Typically very fast unless you have hundreds of contacts/profiles

**Safety:**
- Checks if profile already exists before adding
- Handles both trainer and NPC contact formats
- Gracefully skips contacts without matching profiles
- Won't crash if phone numbers array is empty or nil

### Troubleshooting

**No Social Links are being added:**
- Verify Social Link profiles are registered with matching names
- Check that phone contacts are visible (not hidden)
- Ensure names match exactly (use `test_phone_integration` to debug)

**Only some contacts are added:**
- This is normal - only contacts with matching profiles are added
- Create Social Link profiles for any missing contacts you want to sync

**Function returns 0:**
- All matching Social Links are already added, OR
- No phone contacts have matching Social Link profiles

### See Also
- `pbAddSocialLink(profile_id)` - Add a single Social Link
- `pbHasSocialLink?(profile_id)` - Check if a Social Link exists
- `pbPhoneRegister` - Register a trainer phone contact
- `pbPhoneRegisterNPC` - Register an NPC phone contact


