extends Node2D

const MAX_KEYS = 1

@export var player: FILE_PATH.PLAYER
@export var door: FILE_PATH.DOOR
@export var current_level: Node2D

var left_map: PackedScene
var right_map: PackedScene

@onready var exit_right: Area2D = $ExitRight
@onready var exit_left: Area2D = $ExitLeft
@onready var spawn_point := get_viewport_rect().size / 2.0

func _ready() -> void:
	exit_right.body_entered.connect(func(body: Node) -> void:
		if body is FILE_PATH.PLAYER:
			var next_map = current_level.next_map.instantiate()
			add_child(next_map)
			current_level.queue_free.call_deferred()
			next_map.global_position = $MapCentrePoint.global_position
			player.global_position = next_map.get_node("SpawnPoint").global_position
			print_debug("Player moved to the next level!")

	)

	exit_left.body_entered.connect(func(body: Node) -> void:
		if body is FILE_PATH.PLAYER:
			print_debug("Player exited to the left - implement level loading here.")
	)
