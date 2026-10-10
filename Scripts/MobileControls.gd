extends Node

static var left_pressed := false
static var right_pressed := false
static var jump_pressed := false
static var fire_pressed := false

func _ready() -> void:
    var layer := CanvasLayer.new()
    layer.name = "TouchLayer"
    layer.layer = 5
    add_child(layer)
    var root := Control.new()
    root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    layer.add_child(root)
    # Keep controls clear of the screen edges and aligned along the bottom.
    make_button(root, "◀", Vector2(24, -108), Vector2(82, 72), "left")
    make_button(root, "▶", Vector2(116, -108), Vector2(82, 72), "right")
    make_button(root, "JUMP", Vector2(-218, -108), Vector2(98, 72), "jump")
    make_button(root, "FIRE", Vector2(-110, -108), Vector2(98, 72), "fire")

func make_button(parent: Control, label_text: String, offset: Vector2, button_size: Vector2, action: String) -> void:
    var b := Button.new()
    b.text = label_text
    b.custom_minimum_size = button_size
    b.size = button_size
    b.add_theme_font_size_override("font_size", 19)
    b.add_theme_color_override("font_color", Color(0.72, 1.0, 1.0, 1.0))
    b.add_theme_color_override("font_hover_color", Color.WHITE)
    b.add_theme_color_override("font_pressed_color", Color.WHITE)
    var normal := StyleBoxFlat.new()
    normal.bg_color = Color(0.015, 0.09, 0.10, 0.72)
    normal.border_color = Color(0.25, 0.86, 0.83, 0.85)
    normal.set_border_width_all(2)
    normal.set_corner_radius_all(10)
    normal.content_margin_left = 8
    normal.content_margin_right = 8
    normal.content_margin_top = 6
    normal.content_margin_bottom = 6
    var pressed := normal.duplicate() as StyleBoxFlat
    pressed.bg_color = Color(0.04, 0.48, 0.40, 0.92)
    b.add_theme_stylebox_override("normal", normal)
    b.add_theme_stylebox_override("hover", normal)
    b.add_theme_stylebox_override("pressed", pressed)
    b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
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
