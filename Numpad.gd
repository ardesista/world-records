@tool
extends Panel
class_name Numpad

@onready var button_ok = $centered/grid/button_ok

@export var button_ok_text := "✓" :
    set(x):
        button_ok_text = x
        if button_ok:
            button_ok.text = button_ok_text

enum BUTTON { D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, BACK, OK }

signal numpad_pressed(n: int)

func _ready() -> void:
    button_ok.text = button_ok_text
