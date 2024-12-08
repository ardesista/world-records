@tool
extends Panel
class_name Numpad

signal numpad_pressed(button: int)

@onready var button_ok = $centered/grid/button_ok

@export var button_ok_text := "✓" :
    set(x):
        button_ok_text = x
        if button_ok:
            button_ok.text = button_ok_text

enum { BUTTON_0, BUTTON_1, BUTTON_2, BUTTON_3, BUTTON_4, BUTTON_5, BUTTON_6, BUTTON_7, BUTTON_8, BUTTON_9, BUTTON_BACK, BUTTON_OK }

const _KEYCODE2BUTTON := {
    KEY_0: BUTTON_0,
    KEY_1: BUTTON_1,
    KEY_2: BUTTON_2,
    KEY_3: BUTTON_3,
    KEY_4: BUTTON_4,
    KEY_5: BUTTON_5,
    KEY_6: BUTTON_6,
    KEY_7: BUTTON_7,
    KEY_8: BUTTON_8,
    KEY_9: BUTTON_9,
    KEY_BACKSPACE: BUTTON_BACK,
    KEY_ENTER: BUTTON_OK
}

func _ready() -> void:
    button_ok.text = button_ok_text

func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed and event.keycode in _KEYCODE2BUTTON:
        emit_signal("numpad_pressed", _KEYCODE2BUTTON[event.keycode])
        
        var wp := get_viewport()
        if wp:
            wp.set_input_as_handled()
