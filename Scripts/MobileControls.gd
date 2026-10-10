extends Node

static var left_pressed := false
static var right_pressed := false
static var jump_pressed := false
static var fire_pressed := false

func _ready() -> void:
    var layer := CanvasLayer.new()
    layer.name = "TouchLayer"
    add_child(layer)
    var root := Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    layer.add_child(root)
    make_button(root, "◀", Vector2(42, -120), Vector2(86, 76), "left")
    make_button(root, "▶", Vector2(138, -120), Vector2(86, 76), "right")
    make_button(root, "JUMP", Vector2(-208, -150), Vector2(94, 64), "jump")
    make_button(root, "FIRE", Vector2(-108, -92), Vector2(94, 64), "fire")

func make_button(parent: Control, label_text: String, offset: Vector2, size: Vector2, action: String) -> void:
    var b := Button.new()
    b.text = label_text
    b.custom_minimum_size = size
    b.size = size
    b.add_theme_font_size_override("font_size", 20)
    b.modulate = Color(0.65, 0.95, 1.0, 0.82)
    if action in ["left", "right"]:
        b.anchor_left = 0.0
        b.anchor_right = 0.0
        b.anchor_top = 1.0
        b.anchor_bottom = 1.0
        b.position = offset
    else:
        b.anchor_left = 1.0
        b.anchor_right = 1.0
        b.anchor_top = 1.0
        b.anchor_bottom = 1.0
        b.position = offset
    parent.add_child(b)
    b.button_down.connect(func(): set_action(action, true))
    b.button_up.connect(func(): set_action(action, false))

func set_action(action: String, value: bool) -> void:
    match action:
        "left": left_pressed = value
        "right": right_pressed = value
        "jump": jump_pressed = value
        "fire": fire_pressed = value
