# Gangtag System
A FiveM resource that adds customizable head tags above players with role-based permissions.

## Features
- Ace-based headtags using ACE permissions
- Configurable display format and height
- Toggle individual or all headtags
- Search functionality for tags
- Speaking indicator changes color when players talk
- Noclip compatibility

## Dependencies
- [ox_lib](https://github.com/overextended/ox_lib)
- [RageUI](https://github.com/Joe-Development/Headtag-Menu/releases/download/release/RageUI.zip)

## Installation
1. Download the latest release
2. Extract to your resources folder
3. Add to your `server.cfg`:


## Configuration
The main configuration file (`config.lua`) allows you to customize:

- Debug mode
- Display format
- Viewing distance
- Menu positioning
- Ace permissions
- And more

### Display Format
You can customize the tag format using these variables:
- `{HEADTAG}` - Player's active tag
- `{SPEAKING}` - Speaking indicator color
- `{SERVER_ID}` - Player's server ID

Example:

```lua
Config.FormatDisplayName = "{HEADTAG} {SPEAKING}[{SERVER_ID}]"
```
