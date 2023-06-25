extends CharacterBody3D

@onready var h := $h
@onready var v := $h/v


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent) -> void:
	const mouse_sensitivity := 0.1

	if event is InputEventMouseMotion:
		var camera_input: Vector2 = event.get_relative()
		h.rotate_y(deg_to_rad(-camera_input.x * mouse_sensitivity))
		v.rotate_x(deg_to_rad(-camera_input.y * mouse_sensitivity))
		v.rotation.x = clamp(v.rotation.x, -PI/2, PI/2)

	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode else Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	const SPEED = 10.0
	const JUMP_VELOCITY = 9.0
	var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

	var input := Vector2(Input.get_axis("w","s"), Input.get_axis("a","d"))

	velocity = _lerp3_xz(velocity, Vector3.ZERO, delta * 5)
	velocity += (h.transform.basis.z * input.x + h.transform.basis.x * input.y) * delta * SPEED
	velocity.y -= gravity * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	velocity.y = clampf(velocity.y, -55, 55)
	move_and_slide()

	# Mesh
	var ske := $CollisionShape3D/MeshInstance3D
	var movement_input_pressed := true if input != Vector2.ZERO else false
	if movement_input_pressed:
		ske.rotation.y = lerp_angle(ske.rotation.y, h.rotation.y + atan2(input.y, input.x), delta * 4)

func _lerp3_xz(from: Vector3, to: Vector3, weight: float) -> Vector3:
	from.x = lerp(from.x, to.x, weight)
	from.z = lerp(from.z, to.x, weight)
	return from
