extends Area2D

export var estado_puerta = 0 # 0 abierto, 1 cerrado, 2 rota
export var num_puerta = 0

enum {abierto, cerrado, rota} # EStados de la puerta

var state

func _ready():
	match estado_puerta:
		0:
			state = abierto # Se puede tener acceso a la estructura
		1:
			state = cerrado # No se puede acceder a la estructura
		2:
			state = rota # El portal de ingreso esta dañado y no se puede acceder

func interaccion(): # Interaccion del jugador o npc con la puerta
	if state == abierto:
		pass
	elif state == cerrado:
		pass
	elif state == rota:
		pass
