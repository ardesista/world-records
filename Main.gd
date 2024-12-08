extends Panel

const LINES_NUM := 5

@onready var current: Label = %current
@onready var game_info: RichTextLabel = %game_info
@onready var leaderboard: RichTextLabel = %leaderboard
@onready var logs: RichTextLabel = %logs

var rng := RandomNumberGenerator.new()
var records: Array
var target_idx: int
var guess_num := 0
var finished := false
@onready var _initial_leaderboard := leaderboard.text
@onready var _initial_logs := logs.text
var _leaderboard_tween: Tween

func _ready() -> void:
    if OS.has_feature("web_android") or OS.has_feature("web_ios") or OS.has_feature("mobile"):
        theme.set_stylebox("hover", "Button", theme.get_stylebox("normal", "Button"))
    new_game(Globals.seed)
   
    print("records=", len(records), " target=", target_idx)
    print(_format_time_ms(records[target_idx].time_ms), " ", records[target_idx].username)

func new_game(seed: int) -> void:
    rng.seed = seed
    records = Consts.gen_records(rng.randi_range(10000, 15000), 11, rng)
    target_idx = rng.randi() % len(records)
    game_info.text = "[center]righe [color=green]%d[/color]\ntrova [color=yellow]%s[/color][/center]" % [ len(records), _format_time_ms(records[target_idx].time_ms) ]
    leaderboard.text = _initial_leaderboard
    logs.text = _initial_logs
    current.text = ""
    guess_num = 0

func guess(n: int):
    if n < 0 or n >= len(records):
        logs.text += "[p][color=red]Errore:[/color] indice %d non valido[/p]" % [ n ]
        return

    guess_num += 1
    finished = (records[n].time_ms == records[target_idx].time_ms)

    var lines: Array[String] = []
    var from := n - LINES_NUM / 2
    var to := n + LINES_NUM / 2 + 1
    
    if from < 0:
        for i in range(-from):
            lines.append("")
        
    for i in range(maxi(0, from), mini(to, len(records))):
        var r: Dictionary = records[i]
        var l := ""
        if i == n:
            l = "[color=green]%d[/color]\t[color=yellow]%s[/color]\t%s" % [ i, _format_time_ms(r.time_ms), r.username ]
            if finished:
                l = "[pulse freq=3.5 color=#ffffff00 ease=-10.0]%s[/pulse]" % [ l ]
        else:
            l = "[color=#ffffff20]%d\t%s\t%s[/color]" % [ i, _format_time_ms(r.time_ms), r.username ]
        lines.append(l)

    if to > len(records):
        for i in range(len(records) - to):
            lines.append("")

    var leaderboard_text := "[p tab_stops=\"230,330\"]" + "\n".join(lines) + "[/p]"

    var logs_line := "[p tab_stops=\"210\"]Tentativo [color=#d60072]#%d[/color]\t" % [ guess_num ]
    if finished:
        logs_line += "[wave amp=50.0 freq=5.0 connected=1]"
    logs_line += "[color=green]%d[/color]\t[color=yellow]%s[/color]" % [ n, _format_time_ms(records[n].time_ms) ]
    if finished:
        logs_line += "[/wave]"
    logs_line += "[/p]"
    if finished:
        logs_line += "\n\n[color=#d60072]VITTORIA in[/color] %d [color=#d60072]tentativi![/color]\n\n\n" % [ guess_num ]

    logs.text += logs_line

    if _leaderboard_tween:
        _leaderboard_tween.kill()
    _leaderboard_tween = create_tween()
    _leaderboard_tween.tween_property(leaderboard, "visible_ratio", .0, .2)
    _leaderboard_tween.tween_callback(func(): leaderboard.text = leaderboard_text)
    _leaderboard_tween.tween_property(leaderboard, "visible_ratio", 1.0, 0.5)

func _on_numpad_pressed(button: int) -> void:
    if finished:
        return
        
    if button == Numpad.BUTTON_BACK:
        if len(current.text) > 0:
            current.text = current.text.substr(0, len(current.text) - 1)
    elif button == Numpad.BUTTON_OK:
        if len(current.text) > 0:
            guess(int(current.text))
            current.text = ""
    elif len(current.text) < 5:
        current.text += str(button)

static func _format_time_ms(t: int) -> String:
    return "%d:%02d.%03d" % [ t / 60000, (t % 60000) / 1000, t % 1000 ]

func _on_quit_button_pressed() -> void:
    get_tree().change_scene_to_file("res://Settings.tscn")
