class_name CallableStateMachine extends RefCounted

enum {
	ENTER,
	UPDATE,
	EXIT
}

var state_collection: Dictionary[Variant, Dictionary] = {}
var state_active: Variant

func add_state(
	state_name: Variant,
	enter_state_callable: Callable,
	update_state_callable: Callable,
	exit_state_callable: Callable
) -> void:
	var state_data: Dictionary[int, Callable] = {
		ENTER: enter_state_callable,
		UPDATE: update_state_callable,
		EXIT: exit_state_callable
	}
	state_collection[state_name] = state_data


func set_initial_state(state_name: Variant) -> void:
	if state_collection.has(state_name):
		_set_state(state_name)
	else:
		push_warning("No state with name " + state_name)

@warning_ignore("unused_parameter")
func update(delta: float) -> void:
	if (
		state_active != null
		and state_collection.has(state_active)
		and state_collection[state_active][UPDATE] != Callable()
	):
		(state_collection[state_active][UPDATE]).call(delta)

func change_state(state_name: Variant) -> void:
	if state_collection.has(state_name):
		_set_state.call_deferred(state_name)
	else:
		push_warning("No state with name " + state_name)


# Internal
func _set_state(state_name: Variant) -> void:
	if state_active != null:
		var exit_callable = state_collection[state_active][EXIT]
		if !exit_callable.is_null():
			exit_callable.call()
	
	state_active = state_name
	
	var enter_callable = state_collection[state_active][ENTER]
	if !enter_callable.is_null():
		enter_callable.call()