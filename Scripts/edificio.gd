extends StaticBody2D

var num_edificio = 0
export var estado_puerta = 0 # 0 abierto, 1 cerrado, 2 rota

func _ready():
	$puerta.num_puerta = num_edificio
	
