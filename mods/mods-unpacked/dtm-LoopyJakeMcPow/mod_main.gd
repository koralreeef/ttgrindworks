extends Node


const MOD_DIR := "dtm-LoopyJakeMcPow"
const MOD_LOG_NAME := "dtm-LoopyJakeMcPow:Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

func _init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(MOD_DIR)
	install_script_extensions()
	install_script_hook_files()

func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")

func install_script_hook_files() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")

func _ready() -> void:
	ModLoaderLog.info("Ready!", MOD_LOG_NAME)
	# NOTE: preloading causes issues, call normal load here
	var character : PlayerCharacter = load("res://mods-unpacked/dtm-LoopyJakeMcPow/loopy_jake_mcpow.tres")
	CustomToonRegistry.CUSTOM_TOONS.append(character)
	CustomToonRegistry.CUSTOM_TOON_SETUPS[character.character_name] = Callable(self, "loopyjakemcpow")
	print("Added Loopy Jake McPow to CustomToonRegistry")
	
func loopyjakemcpow(player: Player):
	player.stats.gags_unlocked['Drop'] = 1
	player.stats.gags_unlocked['Squirt'] = 1
