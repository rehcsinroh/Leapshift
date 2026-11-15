extends Area2D

@export var normal_music: AudioStreamPlayer
@export var win_music: AudioStreamPlayer

var finished = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is CharacterBody2D and not finished:
		finished = true
		play_win_music()

func play_win_music():
	# Fade out normal music
	var fade = create_tween()

	fade.tween_property(
		normal_music,
		"volume_db",
		-80.0,
		3.0
	)

	# Wait until the fade finishes
	await fade.finished

	normal_music.stop()

	# Start victory music
	win_music.play()
