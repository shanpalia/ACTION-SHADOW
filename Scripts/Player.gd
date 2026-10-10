extends CharacterBody3D

@export var move_speed: float = 7.0
@export var jump_velocity: float = 8.5
@export var gravity: float = 22.0

var health := 100
var facing := 1.0
var fire_cooldown := 0.0

func _physics_process(delta: float) -> void:
    fire_cooldown = maxf(0.0, fire_cooldown - delta)
    var axis := Input.get_axis("move_left", "move_right")
    if MobileControls.left_pressed:
        axis = -1.0
    elif MobileControls.right_pressed:
        axis = 1.0
    if absf(axis) > 0.01:
        facing = signf(axis)
    velocity.x = axis * move_speed
    velocity.z = 0.0
    if not is_on_floor():
        velocity.y -= gravity * delta
    elif Input.is_action_just_pressed("jump") or MobileControls.jump_pressed:
        velocity.y = jump_velocity
    if (Input.is_action_pressed("fire") or MobileControls.fire_pressed) and fire_cooldown <= 0.0:
        shoot()
        fire_cooldown = 0.22
    move_and_slide()
    rotation.y = 0.0 if facing > 0 else PI

func shoot() -> void:
    var shot := Area3D.new()
    shot.name = "PlayerShot"
    shot.set_script(load("res://Scripts/Projectile.gd"))
    get_tree().current_scene.add_child(shot)
    shot.global_position = global_position + Vector3(facing * 0.9, 0.65, 0)
    shot.direction = facing

func take_damage(amount: int) -> void:
    health -= amount
    GameState.set_health(health)
    if health <= 0:
        health = 100
        global_position = Vector3(-4, 1, 0)
        GameState.set_health(health)
