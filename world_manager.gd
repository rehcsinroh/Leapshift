extends Node

signal world_changed(new_world)

enum World {
	A,
	B
}

var current_world: World = World.B

@export var world_a: Node2D
@export var world_b: Node2D
@export var transparency: float

@export var background: ColorRect

@export var color_a: Color = Color("#555555")
@export var color_b: Color = Color("#AAAAAA")

@export var fade_duration: float = 0.6

var checkpoint_position: Vector2
var color_tween: Tween

func _ready():
	checkpoint_position = get_parent().get_node("Player").global_position
	update_worlds()


func set_checkpoint(new_position: Vector2):
	checkpoint_position = new_position
	print("Checkpoint activated at: ", new_position)

func respawn_player():
	var player = get_parent().get_node("Player")
	player.global_position = checkpoint_position
	player.velocity = Vector2.ZERO

func switch_world():
	if current_world == World.A:
		current_world = World.B
	else:
		current_world = World.A
	update_background()
	update_worlds()
	world_changed.emit(current_world)

func update_background():

	if color_tween and color_tween.is_running():
		color_tween.kill()

	color_tween = create_tween()

	var target_color = color_a if current_world == World.A else color_b

	color_tween.tween_property(
		background,
		"color",
		target_color,
		fade_duration
	)

func update_worlds():
	world_a.process_mode = Node.PROCESS_MODE_INHERIT if current_world == World.A else Node.PROCESS_MODE_DISABLED
	world_b.process_mode = Node.PROCESS_MODE_INHERIT if current_world == World.B else Node.PROCESS_MODE_DISABLED

	world_a.z_index = 0 if current_world == World.A else 1
	world_b.z_index = 0 if current_world == World.B else 1

	world_a.modulate.a = 1.0 if current_world == World.A else transparency
	world_b.modulate.a = 1.0 if current_world == World.B else transparency

	world_a.get_node("WorldATiles").collision_enabled = current_world == World.A
	world_b.get_node("WorldBTiles").collision_enabled = current_world == World.B
