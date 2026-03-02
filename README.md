# RobeSurvivors

A cute roguelike bullet-heaven game built in Godot 4.3.

## Game Summary
**Title:** RobeSurvivors
**Genre:** Cute roguelike bullet-heaven (Vampire Survivors + Binding of Isaac)
**Core Fantasy:** Little wizard starts in heart-patterned underwear. Picks up robes that become both his weapon and his outfit (sleeves shoot fire, fabric spins, etc.). Hats give pure stat buffs and stack. Fight adorable enemies (bunnies with carrot guns, gummy bears that split, lollipop soldiers, exploding cupcakes, etc.) in procedurally generated candy-kingdom levels.

## Controls
- **WASD / Arrow Keys**: Movement
- **Controller Left Stick**: Movement
- **Mouse**: Aim Direction
- **F11 / Alt+Enter**: Toggle Fullscreen
- **Attacks**: Automatic

## Playable Builds & Downloads
You can download the latest pre-compiled versions of RobeSurvivors from the [GitHub Releases](https://github.com/TarYubi/Tiny-Robes/releases) page.

### Manual Export Instructions
If you want to build the executable yourself:
1. Download [Godot 4.3](https://godotengine.org/).
2. Clone this repository.
3. Open the project in Godot 4.3.
4. Go to **Editor > Export...**.
5. Select the desired preset (**Windows Desktop**, **macOS**, or **Linux/X11**).
6. Click **Export Project** and choose a destination.
7. Ensure "Export With Debug" is off for a release build.

*Note: First-time export may require downloading templates via **Editor > Manage Export Templates**.*

### Troubleshooting
- **Windows**: Antivirus might flag the .exe as a false positive. You can safely allow it.
- **macOS**: Gatekeeper may block the app. Right-click the app and select **Open** to bypass.
- **Linux**: You may need to give the binary execution permissions: `chmod +x RobeSurvivors.x86_64`.

### Fullscreen Support
RobeSurvivors supports full screen mode to provide an immersive experience. You can toggle it using **F11** or **Alt+Enter**, or by clicking the button in the top-right corner of the HUD. Your preference will be saved and remembered for future play sessions.

## Setup and Run (Development)
1. Download [Godot 4.3](https://godotengine.org/).
2. Clone this repository.
3. Open Godot and import the `project.godot` file.
4. Press F5 to play.

## Project Structure
- `scenes/`: Godot scenes (.tscn)
- `scripts/`: GDScript files (.gd)
- `assets/sprites/`: Placeholder and final pixel art (32x32 base)
- `assets/sounds/`: Sound effects
- `assets/music/`: Background music
- `resources/`: Data resources for Robes and Hats
- `autoload/`: Global singleton scripts

## How to add more Robes/Hats
- **Robes**: Create a new `RobeData` resource in `resources/robes/`, assign a sprite, weapon scene, and stats.
- **Hats**: Create a new `HatData` resource in `resources/hats/`, assign stats and colors.

## License
MIT
