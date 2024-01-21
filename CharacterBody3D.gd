extends CharacterBody3D


var SPEED = 5.0
const JUMP_VELOCITY = 3.0
var DRAG = 0.87

var is_sliding = false

@export var sensitivity = 1500

@onready var pivot = %Pivot

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("a", "d", "w", "s")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and !is_sliding:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#		velocity.z = move_toward(velocity.z, 0, SPEED)

		velocity.x *= DRAG
		velocity.z *= DRAG

	if Input.is_action_pressed("shift"):
		SPEED = 8.0
	else:
		SPEED = 5.0
		
	if Input.is_action_just_pressed("ctrl"):
		velocity.x *= 1.1
		velocity.z *= 1.1
	if Input.is_action_pressed("ctrl"):
		is_sliding = true
		DRAG = 0.99
		scale = Vector3(1, 0.7, 1)
	else:
		is_sliding = false
		DRAG = 0.87
		scale = Vector3(1, 1, 1)

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / sensitivity
		pivot.rotation.x -= event.relative.y / sensitivity
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90), deg_to_rad(90))
