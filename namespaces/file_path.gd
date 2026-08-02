class_name FILE_PATH extends RefCounted

const ASSET_PATH = "res://assets/"

const PLAYER = preload(ASSET_PATH + "/scripts/player.gd")
const DOOR = preload(ASSET_PATH + "scripts/exit.gd")

# ---------- SFX ----------
const SFX_LEVEL_COMPLETE = preload(ASSET_PATH + "sfx/level_cleared.ogg")
const SFX_DOOR_OPEN = preload(ASSET_PATH + "sfx/sliding_door.ogg")
const SFX_COIN_PICKUP = preload(ASSET_PATH + "sfx/coin_pickup.ogg")
const SFX_CLICK = preload(ASSET_PATH + "sfx/click.ogg")
const SFX_WHOOSH = preload(ASSET_PATH + "sfx/whoosh.ogg")
const SFX_WHOOSH_REVERSE = preload(ASSET_PATH + "sfx/whoosh_reverse.ogg")
const SFX_POP = preload(ASSET_PATH + "sfx/pop.ogg")
const SFX_PAY = preload(ASSET_PATH + "sfx/pay.ogg")
const SFX_ERROR = preload(ASSET_PATH + "sfx/error.ogg")

# ---------- Input ----------
const INPUT_TOUCH = preload(ASSET_PATH + "scripts/input_touch.gd")


# ---------- UI ----------
const UI_INV_ITEM = "res://ui/inv_item.ui.tscn"

# ---------- Models ----------
const MODEL_INVENTORY = preload("res://data_models/inventory.model.gd")
const MODEL_LEVEL_STATE = preload("res://data_models/level_state.model.gd")
