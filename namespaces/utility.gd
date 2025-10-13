class_name Utility extends Node

static func create_sfx_player(sfx: AudioStream) -> AudioStreamPlayer:
	var audio_player = AudioStreamPlayer.new()
	audio_player.stream = sfx
	audio_player.bus = "SFX"
	return audio_player

static func add_action_for_key(tag: String, key: int) -> void:
	InputMap.add_action(tag)
	var event = InputEventKey.new()
	event.physical_keycode = key
	InputMap.action_add_event(tag, event)

static func add_timer_with_callable(callable: Callable) -> Timer:
	var timer = Timer.new()
	timer.autostart = true
	timer.timeout.connect(callable)
	return timer