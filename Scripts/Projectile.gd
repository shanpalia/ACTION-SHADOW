extends Area3D

@export var speed := 18.0
var direction := 1.0
var life := 1.4

func _ready() -> void:
    collision_layer = 0
    collision_mask = 1
    monitoring = true
    monitorable = false
    var mesh := MeshInstance3D.new()
    var projectile_mesh := BoxMesh.new()
    projectile_mesh.size = Vector3(0.45, 0.12, 0.12)
    mesh.mesh = projectile_mesh
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color(0.2, 0.95, 1.0)
    mat.emission_enabled = true
    mat.emission = Color(0.05, 0.7, 1.0)
    mesh.material_override = mat
    add_child(mesh)
    var collision := CollisionShape3D.new()
    var shape := SphereShape3D.new()
    shape.radius = 0.22
    collision.shape = shape
    add_child(collision)
    body_entered.connect(_on_body_entered)
    area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
    global_position.x += direction * speed * delta
    life -= delta
    if life <= 0.0:
        queue_free()

func _on_body_entered(body: Node3D) -> void:
    if body.is_in_group("enemies") and body.has_method("take_damage"):
        body.take_damage(1)
        queue_free()

func _on_area_entered(area: Area3D) -> void:
    if area.is_in_group("enemies") and area.has_method("take_damage"):
        area.take_damage(1)
        queue_free()
