extends KinematicBody2D

# Variables para el movimiento del personaje
export var speed = 30
var direccion_x = 0
var direccion_y = 0

var distancia = Vector2()
var velocidad = Vector2()

var mirar_x = true # Variable para oreientar a donde mira el jugador

# Variable para el patrullaje de el npc
var start_position = Vector2() # Ubicacion actual
var end_position = Vector2(50, 0) # Rango de distancia que recore npc
var last_postion = Vector2()

enum {patrulla, persecucion, retorno}

var state = patrulla
var vel_max = 1

func _ready():
	start_position = position
	$anim.play("idleUno")
	
func _physics_process(delta):
	
	movimiento(delta)

func movimiento(delta):
#	direccion_x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
#	direccion_y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	_proceso_patrulla()
	sprite()
	
	distancia.x = speed * delta
	velocidad.x = (direccion_x * distancia.x) / delta
	distancia.y = speed * delta
	velocidad.y = (direccion_y * distancia.y) / delta
	move_and_slide(velocidad, Vector2())
	
#	velocidad.x = clamp(velocidad.x, -vel_max, vel_max)
#	print (velocidad.x)

func sprite(): # Cambio de posicion de sprite en x and y
	if direccion_x != 0:
		mirar_x = true 
		if direccion_x > 0:
			$Sprite.flip_h = false
		elif direccion_x < 0:
			$Sprite.flip_h = true
		$anim.play("mov_x")
			
	elif direccion_y != 0:
		mirar_x = false
		if direccion_y > 0:
			$Sprite.flip_v = false
		elif direccion_y < 0:
			$Sprite.flip_v = true
		$anim.play("mov_y")
	elif direccion_x == 0 and direccion_y == 0:
		if !mirar_x:
			$anim.play("idle_y")
		else:
			$anim.play("idle_x")
	
func _proceso_patrulla():
	if global_position.x > start_position.x + end_position.x: # Si se pasa de end_position entonces regresa
		direccion_x -= 0.1
		
	elif global_position.x < start_position.x + end_position.x:
		direccion_x += 0.1
	
func _persecucion():
	pass
	
func _retornar():
	pass
	
