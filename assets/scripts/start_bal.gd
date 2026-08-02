extends Area2D

@export var init_balance: int = 30

# Animation control variables
@export var animation_speed: float = 2.0 # How fast it bobs (higher = faster)
@export var animation_amplitude: float = 10.0 # How far it moves up/down (pixels)
@export var rise_fall_asymmetry: float = 0.0 # -1.0 to 1.0, adjusts rise vs fall timing

var base_position: Vector2
var time_offset: float

func _ready() -> void:
	# Store the starting position
	base_position = position
	# Random offset so multiple objects don't sync
	time_offset = randf() * PI * 2
	
	body_entered.connect(func(body) -> void:
		if body.name == "Player":
			body.set_balance(body.coins + init_balance) # set initial balance
			destroy()
	)

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	# Calculate time with speed control
	var time_value = (Time.get_ticks_msec() / 1000.0) * animation_speed + time_offset
	
	# Apply asymmetry to create different rise/fall speeds
	var wave_input = time_value + sin(time_value * 2.0) * rise_fall_asymmetry * 0.3
	
	# Calculate the bobbing offset
	var bob_offset = sin(wave_input) * animation_amplitude
	
	# Apply to position
	position.y = base_position.y + bob_offset

func destroy() -> void:
	var sfx = Utility.create_sfx_player(FILE_PATH.SFX_COIN_PICKUP)
	add_child(sfx)
	sfx.play()
	hide()
	sfx.finished.connect(queue_free)
