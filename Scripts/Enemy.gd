extends CharacterBody3D

@export var speed := 1.8
@export var max_health := 3
var health := 3
var hit_timer := 0.0

func _ready() -> void:
    add_to_group("enemies")
    health = max_health

func _physics_process(delta: float) -> void:
    hit_timer = maxf(0.0, hit_timer - delta)
    var player := get_tree().get_first_node_in_group("player")
    if player and is_instance_valid(player):
        var dx: float = player.global_position.x - global_position.x
        if absf(dx) > 1.15:
            velocity.x = signf(dx) * speed
        else:
            velocity.x = 0.0
        rotation.y = 0.0 if dx >= 0 else PI
    if not is_on_floor():
        velocity.y -= 22.0 * delta
    move_and_slide()

func take_damage(amount: int) -> void:
    health -= amount
    if health <= 0:
        GameState.add_score(100)
        queue_free()
