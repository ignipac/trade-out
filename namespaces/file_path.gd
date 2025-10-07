class_name FILE_PATH extends RefCounted

const PLAYER = preload("res://scripts/player.gd")
const DOOR = preload("res://scripts/exit.gd")

# ---------- SFX ----------
const SFX_LEVEL_COMPLETE = preload("res://sfx/level_cleared.ogg")
const SFX_DOOR_OPEN = preload("res://sfx/sliding_door.ogg")
const SFX_COIN_PICKUP = preload("res://sfx/coin_pickup.ogg")
const SFX_CLICK = preload("res://sfx/click.ogg")
const SFX_WHOOSH = preload("res://sfx/whoosh.ogg")
const SFX_WHOOSH_REVERSE = preload("res://sfx/whoosh_reverse.ogg")
const SFX_POP = preload("res://sfx/pop.ogg")
const SFX_PAY = preload("res://sfx/pay.ogg")
const SFX_ERROR = preload("res://sfx/error.ogg")

# ---------- Input ----------
const INPUT_TOUCH = preload("res://scripts/input_handler_touch.gd")


# ---------- UI ----------
const UI_INV_ITEM = "res://ui/ui_inv_item.tscn"


# ---------- Models ----------
const MODEL_INVENTORY = preload("res://data_models/inventory.model.gd")
const MODEL_MARKET = preload("res://data_models/market.model.gd")
const MODEL_LEVEL_STATE = preload("res://data_models/level_state.model.gd")