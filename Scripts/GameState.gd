extends Node

signal hud_changed
var health := 100
var score := 0
var stage_index := 0
var stage_names := ["Jungle Outpost", "Ironclad Base", "Red Dune Canyon", "Frostline Fortress", "Eclipse Core"]
var stage_moods := [
    {"sky": Color(0.08,0.22,0.20), "ground": Color(0.18,0.34,0.22), "accent": Color(0.2,0.95,0.75)},
    {"sky": Color(0.10,0.14,0.22), "ground": Color(0.22,0.25,0.31), "accent": Color(1.0,0.45,0.18)},
    {"sky": Color(0.35,0.18,0.08), "ground": Color(0.48,0.28,0.12), "accent": Color(1.0,0.72,0.18)},
    {"sky": Color(0.12,0.23,0.34), "ground": Color(0.55,0.72,0.80), "accent": Color(0.3,0.85,1.0)},
    {"sky": Color(0.12,0.06,0.22), "ground": Color(0.20,0.15,0.32), "accent": Color(0.85,0.3,1.0)}
]

func set_health(value: int) -> void:
    health = value
    hud_changed.emit()

func add_score(value: int) -> void:
    score += value
    hud_changed.emit()

func next_stage() -> void:
    stage_index = (stage_index + 1) % stage_names.size()
    health = 100
    hud_changed.emit()
