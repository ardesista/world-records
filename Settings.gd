extends Panel

@onready var seed: Label = %seed

func _ready() -> void:
    if OS.has_feature("web_android") or OS.has_feature("web_ios") or OS.has_feature("mobile"):
        theme.set_stylebox("hover", "Button", theme.get_stylebox("normal", "Button"))

    if OS.has_feature("web"):
        %quit_button.visible = false

    seed.text = str(Globals.seed)

func _on_numpad_pressed(button: int) -> void:
    if button == Numpad.BUTTON_BACK:
        if len(seed.text) > 0:
            seed.text = seed.text.substr(0, len(seed.text) - 1)
    elif button == Numpad.BUTTON_OK:
        Globals.seed = int(seed.text) if len(seed.text) > 0 else (randi() % 1000000)
        get_tree().change_scene_to_file("res://Main.tscn")
    elif len(seed.text) < 9:
        seed.text += str(button)

func _on_randomize_seed_pressed() -> void:
    seed.text = str(randi() % 1000000)

func _on_quit_button_pressed() -> void:
    get_tree().quit()
