extends Node


const MOD_DIR := "dtm-MoreCharacters"
const MOD_LOG_NAME := "dtm-MoreCharacters:Main"

var mod_dir_path := ""
var extensions_dir_path := ""
var translations_dir_path := ""

func _init() -> void:
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(MOD_DIR)
	# Add extensions
	install_script_extensions()
	# Add translations
	add_translations()


func install_script_extensions() -> void:
	extensions_dir_path = mod_dir_path.path_join("extensions")
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("objects/globals/globals.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("scenes/title_screen/title_screen.gd"))
	ModLoaderMod.install_script_extension(extensions_dir_path.path_join("scenes/falling_scene/falling_scene.gd"))


func add_translations() -> void:
	translations_dir_path = mod_dir_path.path_join("translations")
	# ModLoaderMod.add_translation(translations_dir_path.path_join(...))


func _ready() -> void:
	ModLoaderLog.info("Ready!", MOD_LOG_NAME)
