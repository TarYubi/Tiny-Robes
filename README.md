# RobeSurvivors

A cute roguelike bullet-heaven game built in Godot 4.3.

## Game Summary
**Title:** RobeSurvivors
**Genre:** Cute roguelike bullet-heaven (Vampire Survivors + Binding of Isaac)
**Core Fantasy:** Little wizard starts in heart-patterned underwear. Picks up robes that become both his weapon and his outfit (sleeves shoot fire, fabric spins, etc.). Hats give pure stat buffs and stack. Fight adorable enemies (bunnies with carrot guns, gummy bears that split, lollipop soldiers, exploding cupcakes, etc.) in procedurally generated candy-kingdom levels.

## Controls
- **WASD / Arrow Keys**: Movement
- **Controller Left Stick**: Movement
- **Attacks**: Automatic

## Setup and Run
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
