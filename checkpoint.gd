extends Area2D

@export var world_manager: Node

var activated = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is CharacterBody2D and not activated:
		activated = true
		world_manager.set_checkpoint(global_position)

		$Sprite2D.material.set_shader_parameter("invert", true)
