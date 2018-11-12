extends Camera2D

onready var screen_size = Vector2(1024, 600)
onready var player = get_node("/root/Node2D/Player")

var h_margin = 0
var v_margin = 200

var acc = 10

func _ready():
	position = screen_size/2
	
	h_margin = screen_size.x/2
	pass

func _physics_process(delta):
	if offset.x + screen_size.x - player.position.x < h_margin:
		var intended_pos = h_margin + player.position.x - screen_size.x
		offset.x = lerp(offset.x, intended_pos, acc*delta)
	if player.position.x - offset.x < h_margin:
		var intended_pos = player.position.x - h_margin
		offset.x = lerp(offset.x, intended_pos, acc*delta)
		
	if offset.y + screen_size.y - player.position.y < v_margin:
		var intended_pos = v_margin + player.position.y - screen_size.y
		offset.y = lerp(offset.y, intended_pos, acc*delta)
	if player.position.y - offset.y < v_margin:
		var intended_pos = player.position.y - v_margin
		offset.y = lerp(offset.y, intended_pos, acc*delta)
	pass
