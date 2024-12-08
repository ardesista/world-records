extends Panel

enum BUTTON { D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, BACK, OK }
const LINES_NUM := 5

@onready var current: Label = %current
@onready var game_info: RichTextLabel = %game_info
@onready var leaderboard: RichTextLabel = %leaderboard
@onready var log: RichTextLabel = %log

var rng := RandomNumberGenerator.new()
var records: Array
var target_idx: int
var guess_num := 0

var _leaderboard_tween: Tween

func _ready() -> void:
    new_game()
   
    print(len(records), " ", target_idx)
    print(records[target_idx])

func new_game() -> void:
    records = Consts.gen_records(rng.randi_range(10000, 15000))
    target_idx = rng.randi() % len(records)
    game_info.text = "[center]risultati [color=yellow]%d[/color]\ntrova [color=green]%s[/color][/center]" % [ len(records), _format_time_ms(records[target_idx].time_ms) ]
    leaderboard.text = ""
    current.text = ""
    log.text = ""
    guess_num = 0

func guess(n: int):
    if n < 0 or n >= len(records):
        log.text += ("\n" if len(log.text) > 0 else "") + "[color=red]Errore:[/color] indice %d non valido" % [ n ]
        return

    guess_num += 1

    var lines: Array[String] = []
    var from := n - LINES_NUM / 2
    var to := n + LINES_NUM / 2 + 1
    
    if from < 0:
        for i in range(-from):
            lines.append("")
        
    for i in range(maxi(0, from), mini(to, len(records))):
        var r: Dictionary = records[i]
        var l := "%5d.\t[color=green]%s[/color]\t%s" % [ i, _format_time_ms(r.time_ms), r.username ]
        if i == n and n == target_idx:
            l = "[pulse freq=3.5 color=#ff0000ff ease=-6.0]%s[/pulse]" % [ l ]
        lines.append(l)

    if to > len(records):
        for i in range(len(records) - to):
            lines.append("")

    var leaderboard_text := "[p tab_stops=\"250,70\"]" + "\n".join(lines) + "[/p]"

    var log_line := "Tentativo [color=purple]#%d[/color]\t" % [ guess_num ]
    if n == target_idx:
        log_line += "[wave amp=50.0 freq=5.0 connected=1]"
    log_line += "%-5d\t[color=green]%s[/color]" % [ n, _format_time_ms(records[n].time_ms) ]
    if n == target_idx:
        log_line += "[/wave]"

    log.text += ("\n" if len(log.text) > 0 else "") + log_line

    if _leaderboard_tween:
        _leaderboard_tween.kill()
    _leaderboard_tween = create_tween()
    _leaderboard_tween.tween_property(leaderboard, "visible_ratio", .0, .2)
    _leaderboard_tween.tween_callback(func(): leaderboard.text = leaderboard_text)
    _leaderboard_tween.tween_property(leaderboard, "visible_ratio", 1.0, 0.5)

func button_pressed(button: int) -> void:
    if button == BUTTON.BACK:
        if len(current.text) > 0:
            current.text = current.text.substr(0, len(current.text) - 1)
    elif button == BUTTON.OK:
        if len(current.text) > 0:
            guess(int(current.text))
            current.text = ""
    else:
        current.text += str(button)

static func _format_time_ms(t: int) -> String:
    return "%2d:%02d.%03d" % [ t / 60000, (t % 60000) / 1000, t % 1000 ]
