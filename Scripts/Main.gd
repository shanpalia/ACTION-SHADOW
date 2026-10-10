extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var hud_label: Label = $HUD/Info
@onready var stage_label: Label = $HUD/Stage
var stage_length := 34.0
var stage_spawned := false

func _ready() -> void:
    # Keep the gameplay view immersive on Android and desktop fullscreen.
    if OS.has_feature("android"):
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
    # Build a clearly visible modern HUD rather than the old plain labels.
    hud_label.add_theme_color_override("font_color", Color(0.88, 1.0, 1.0))
    stage_label.add_theme_color_override("font_color", Color(0.38, 1.0, 0.79))
    hud_label.add_theme_font_size_override("font_size", 18)
    stage_label.add_theme_font_size_override("font_size", 20)
    hud_label.add_theme_constant_override("outline_size", 3)
    hud_label.add_theme_color_override("font_outline_color", Color(0.01, 0.08, 0.09, 0.95))
    stage_label.add_theme_constant_override("outline_size", 3)
    stage_label.add_theme_color_override("font_outline_color", Color(0.01, 0.08, 0.09, 0.95))
    var hud_panel := Panel.new()
    hud_panel.name = "HUDPanel"
    hud_panel.position = Vector2(16, 14)
    hud_panel.size = Vector2(468, 106)
    var panel_style := StyleBoxFlat.new()
    panel_style.bg_color = Color(0.008, 0.025, 0.04, 0.84)
    panel_style.border_color = Color(0.05, 0.95, 0.77, 0.95)
    panel_style.set_border_width_all(2)
    panel_style.set_corner_radius_all(10)
    panel_style.shadow_color = Color(0.0, 0.9, 0.72, 0.18)
    panel_style.shadow_size = 8
    hud_panel.add_theme_stylebox_override("panel", panel_style)
    hud_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
    $HUD.add_child(hud_panel)
    $HUD.move_child(hud_panel, 0)
    stage_label.position = Vector2(30, 20)
    stage_label.size = Vector2(438, 32)
    hud_label.position = Vector2(30, 56)
    hud_label.size = Vector2(438, 30)
    # Minimal futuristic health bar under the status text.
    var health_back := ColorRect.new()
    health_back.name = "HealthBarBack"
    health_back.position = Vector2(30, 91)
    health_back.size = Vector2(430, 5)
    health_back.color = Color(0.12, 0.20, 0.23, 1.0)
    health_back.mouse_filter = Control.MOUSE_FILTER_IGNORE
    $HUD.add_child(health_back)
    var health_fill := ColorRect.new()
    health_fill.name = "HealthBar"
    health_fill.position = Vector2(30, 91)
    health_fill.size = Vector2(430, 5)
    health_fill.color = Color(0.05, 1.0, 0.63, 1.0)
    health_fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
    $HUD.add_child(health_fill)
    # Small aiming reticle, centered in the play area.
    var reticle := Label.new()
    reticle.name = "Reticle"
    reticle.text = "+"
    reticle.position = Vector2(628, 330)
    reticle.size = Vector2(24, 30)
    reticle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    reticle.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    reticle.add_theme_font_size_override("font_size", 26)
    reticle.add_theme_color_override("font_color", Color(0.35, 1.0, 0.84, 0.85))
    reticle.add_theme_constant_override("outline_size", 2)
    reticle.add_theme_color_override("font_outline_color", Color(0.0, 0.05, 0.07, 1.0))
    reticle.mouse_filter = Control.MOUSE_FILTER_IGNORE
    $HUD.add_child(reticle)
    GameState.hud_changed.connect(update_hud)
    build_environment()
    spawn_enemies()
    update_hud()

func _process(_delta: float) -> void:
    if player.global_position.x > stage_length and not stage_spawned:
        stage_spawned = true
        GameState.next_stage()
        player.global_position.x = -8
        clear_stage_objects()
        build_environment()
        spawn_enemies()
        stage_spawned = false
    if player.global_position.x < -12:
        player.global_position.x = -12

func build_environment() -> void:
    var mood: Dictionary = GameState.stage_moods[GameState.stage_index]
    var world_env: Environment = $WorldEnvironment.environment
    world_env.background_mode = Environment.BG_COLOR
    world_env.background_color = mood.sky
    var ground_mat := StandardMaterial3D.new()
    ground_mat.albedo_color = mood.ground
    $Ground/Mesh.material_override = ground_mat
    $HUD/Stage.text = "STAGE %d  •  %s" % [GameState.stage_index + 1, GameState.stage_names[GameState.stage_index]]
    for old in get_tree().get_nodes_in_group("stage_prop"):
        old.queue_free()
    for i in range(12):
        var pillar := MeshInstance3D.new()
        pillar.add_to_group("stage_prop")
        var mesh := BoxMesh.new()
        mesh.size = Vector3(randf_range(1.0, 2.5), randf_range(2.0, 6.0), 0.5)
        pillar.mesh = mesh
        pillar.position = Vector3(-8 + i * 4.0, mesh.size.y * 0.5 - 0.2, -5.0)
        var mat := StandardMaterial3D.new()
        mat.albedo_color = mood.accent.darkened(randf_range(0.05, 0.55))
        pillar.material_override = mat
        add_child(pillar)
    for i in range(7):
        var crate := MeshInstance3D.new()
        crate.add_to_group("stage_prop")
        var mesh2 := BoxMesh.new()
        mesh2.size = Vector3(1.2, 0.9, 1.1)
        crate.mesh = mesh2
        crate.position = Vector3(-5 + i * 5.3, 0.35, -0.7)
        var mat2 := StandardMaterial3D.new()
        mat2.albedo_color = mood.accent.darkened(0.65)
        crate.material_override = mat2
        add_child(crate)

func spawn_enemies() -> void:
    for i in range(5):
        var enemy := CharacterBody3D.new()
        enemy.name = "Enemy"
        enemy.set_script(load("res://Scripts/Enemy.gd"))
        enemy.position = Vector3(3 + i * 5.5, 1, 0)
        var mesh := MeshInstance3D.new()
        var capsule := CapsuleMesh.new()
        capsule.radius = 0.42
        capsule.height = 1.7
        mesh.mesh = capsule
        var mat := StandardMaterial3D.new()
        mat.albedo_color = GameState.stage_moods[GameState.stage_index].accent
        mesh.material_override = mat
        enemy.add_child(mesh)
        var collision := CollisionShape3D.new()
        var shape := CapsuleShape3D.new()
        shape.radius = 0.42
        shape.height = 1.7
        collision.shape = shape
        enemy.add_child(collision)
        add_child(enemy)
    var boss := CharacterBody3D.new()
    boss.name = "StageBoss"
    boss.set_script(load("res://Scripts/Enemy.gd"))
    boss.speed = 0.8
    boss.max_health = 12
    boss.position = Vector3(29, 1.2, 0)
    var boss_mesh := MeshInstance3D.new()
    var boss_shape_mesh := BoxMesh.new()
    boss_shape_mesh.size = Vector3(2.0, 2.4, 1.1)
    boss_mesh.mesh = boss_shape_mesh
    var boss_mat := StandardMaterial3D.new()
    boss_mat.albedo_color = GameState.stage_moods[GameState.stage_index].accent
    boss_mat.emission_enabled = true
    boss_mat.emission = boss_mat.albedo_color * 0.35
    boss_mesh.material_override = boss_mat
    boss.add_child(boss_mesh)
    var boss_collision := CollisionShape3D.new()
    var boss_shape := BoxShape3D.new()
    boss_shape.size = Vector3(2.0, 2.4, 1.1)
    boss_collision.shape = boss_shape
    boss.add_child(boss_collision)
    add_child(boss)

func clear_stage_objects() -> void:
    for child in get_children():
        if child.is_in_group("enemies") or child.name == "StageBoss":
            child.queue_free()

func update_hud() -> void:
    if is_instance_valid(hud_label):
        hud_label.text = "HP %d   /   ENERGY GUN   /   SCORE %06d" % [GameState.health, GameState.score]
