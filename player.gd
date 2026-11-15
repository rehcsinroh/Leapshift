extends CharacterBody2D

# Movement settings
@export var speed: float = 250.0
@export var jump_velocity: float = -400.0
@export var death_y: float = 200.0
var wall_jump_timer = 0.0
const WALL_JUMP_LOCK = 0.2
var WALL_JUMP_X: float = 200
var WALL_JUMP_Y: float = -250
@export var coyote_time: float = 1.5
@export var jump_buffering: float = 1.5
var coyote_timer: int = coyote_time
var jump_buffering_timer = jump_buffering

@export var world_manager: Node

# Gravity
var gravity: float = 980.0
var alternate_sprite: bool = false

func _physics_process(delta: float):
	if is_on_floor():
		coyote_timer = coyote_time
	
	
	wall_jump_timer = maxf(wall_jump_timer - delta, 0.0)

	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("move_left", "move_right")

	velocity.x = direction * speed
	if direction < 0:
		$AnimatedSprite2D.flip_h = true
	elif direction > 0:
		$AnimatedSprite2D.flip_h = false
	# Jumping
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
			alternate_sprite = !alternate_sprite
			world_manager.switch_world()
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
		if $AnimatedSprite2D.animation == "idlew" or $AnimatedSprite2D.animation == "idleb":
			if not alternate_sprite:
				$AnimatedSprite2D.play("1w")
			else:
				$AnimatedSprite2D.play("1b")
		elif $AnimatedSprite2D.animation == "1w" or $AnimatedSprite2D.animation == "1b":
			if not alternate_sprite:
				$AnimatedSprite2D.play("2w")
			else:
				$AnimatedSprite2D.play("2b")
		else:
			if not alternate_sprite:
				$AnimatedSprite2D.play("3w")
			else:
				$AnimatedSprite2D.play("3b")
	
	# Move player
	move_and_slide()
	
	if global_position.y > death_y:	
		get_tree().reload_current_scene()
