extends CharacterBody2D

# Movement settings
@export var speed: float = 250.0
@export var jump_velocity: float = -400.0
@export var death_y: float = 200.0
var wall_jump_timer = 0.0
const WALL_JUMP_LOCK = 0.2
var WALL_JUMP_X: float = 100
var WALL_JUMP_Y: float = -250
@export var coyote_time: float = 0.06
@export var jump_buffering: float = 0.06
var coyote_timer: float = coyote_time
var jump_buffering_timer: float = 0.0

@export var world_manager: Node

# Gravity
var gravity: float = 980.0
var alternate_sprite: bool = false

func _physics_process(delta: float):
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	if Input.is_action_just_pressed("jump"):
		jump_buffering_timer = jump_buffering
	else:
		jump_buffering_timer = maxf(jump_buffering_timer - delta, 0.0)

	wall_jump_timer = maxf(wall_jump_timer - delta, 0.0)

	if not is_on_floor():
		if is_on_wall() and velocity.y > 0:
			velocity.y += gravity / 2 * delta
			velocity.y = minf(velocity.y, 120.0)
		else:
			velocity.y += gravity * delta

	var direction = Input.get_axis("move_left", "move_right")
	if wall_jump_timer <= 0:
		velocity.x = direction * speed
	if direction < 0:
		$AnimatedSprite2D.flip_h = true
	elif direction > 0:
		$AnimatedSprite2D.flip_h = false
	# Jumping
	if jump_buffering_timer > 0.0:
		if is_on_floor() or coyote_timer > 0:
			velocity.y = jump_velocity
			alternate_sprite = !alternate_sprite
			world_manager.switch_world()
			coyote_timer = 0
		elif is_on_wall():
			var wall_normal = get_wall_normal()
			velocity.x = wall_normal.x * WALL_JUMP_X	
			velocity.y = WALL_JUMP_Y
			wall_jump_timer = WALL_JUMP_LOCK
		
			alternate_sprite = !alternate_sprite
			world_manager.switch_world()

	if direction == 0:
		if not alternate_sprite:
			$AnimatedSprite2D.play("idlew")
		else:
			$AnimatedSprite2D.play("idleb")
	else:
		if not alternate_sprite:
			$AnimatedSprite2D.play("1w")
		else:
			$AnimatedSprite2D.play("1b")

	
	# Move player
	move_and_slide()
	
	if global_position.y > death_y:	
		get_tree().reload_current_scene()
