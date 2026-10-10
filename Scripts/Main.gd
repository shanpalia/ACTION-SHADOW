extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var hud_label: Label = $HUD/Info
@onready var stage_label: Label = $HUD/Stage
var stage_length := 34.0
var stage_spawned := false

func _ready() -> void:
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
    var world_env := $WorldEnvironment.environment
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
        hud_label.text = "HP %d     ENERGY GUN  •  SCORE %06d" % [GameState.health, GameState.score]
