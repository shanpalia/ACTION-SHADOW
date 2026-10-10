# SHADOW VANGUARD — Game Build Brief

## Goal
Transform the existing Godot 4.3 Android project into an original modern 2.5D side-scrolling run-and-gun game inspired by classic Contra-style gameplay. Keep the existing repository and Android export workflow; do not create a separate demo or a third-person shooter.

## Visual direction
- Modern stylized action-movie aesthetic, not pixel art and not flat placeholder visuals.
- Side-view gameplay with depth from layered parallax backgrounds, cinematic lighting, atmospheric rain/fog, and detailed environments.
- Original elite black-ops commando with proper side-facing run, jump, aim, fire, hit, and death animations.
- First environment: rain-soaked jungle outpost. Later environment themes: shipbreaking yard, futuristic battlefield, alien hive fortress.
- Professional game HUD with health, lives, ammo, weapon, score, mission objective, and boss health.

## Gameplay requirements
- Landscape Android gameplay and responsive multitouch controls.
- Run, jump, crouch if supported, shoot in multiple directions, throw grenades, collect weapon power-ups.
- Scrolling levels, enemy waves, destructible props where practical, checkpoints, mission completion, pause, restart, game over, and victory screens.
- Bosses with learnable attack patterns and multiple phases.
- Synth-meets-orchestra audio direction with strong weapon, impact, explosion, and UI sound effects when assets are available.
- Offline single-player; no fake online services or demo-only buttons.

## Technical requirements
- Preserve Godot 4.x compatibility and the existing Android export pipeline.
- Prefer lightweight assets and effects for mid-range Android devices.
- Do not use copyrighted Contra characters, logos, sprites, music, or copied levels; create original assets and names.
- Never claim that a feature, screenshot test, or APK build works unless it has actually been tested.

## Implementation order
1. Inspect existing scenes/scripts and current build workflow.
2. Make a genuinely playable side-scrolling prototype with real movement, firing, collision, enemies, and camera scrolling.
3. Replace placeholder visuals with original animated character/environment assets and layered backgrounds.
4. Add boss encounter, mission flow, and polished HUD/mobile controls.
5. Run Godot validation and the Android APK workflow; fix failures before calling it complete.
