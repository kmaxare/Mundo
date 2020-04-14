extends KinematicBody2D

var player_node = KinematicBody2D

# Variables para el movimiento del personaje
export var speed = 10
export var distancia = 50 # Distancia que recorrera en x and y el NPC
export var rut_patrullaje = true # Direccion de patrulla false (arriba, abajo), true (derecha, izquierda)

var ubicacion = Vector2()
var mirar_x = true # Variable para oreientar a donde mira el jugador

# Valores de Copia para la distancia y ubicacion
var _copia_end_position
var _copia_ubicacion

# Variable para el patrullaje de el npc
var start_position = Vector2() # Ubicacion actual
var end_position = Vector2(0, 0) # Rango de distancia que rrecore npc
var last_position = Vector2()

enum {patrulla, persecucion, retorno} # Estados del personaje

var state = patrulla
var vel_max = 1
#var llave = 0

#var llave = true
#var copia = true

func _ready():
	start_position = position
	$anim.play("idleUno") 
	end_position = Vector2(distancia, distancia) # Rango de distancia que rrecore npc
	
	_copia_end_position = end_position
	_copia_ubicacion = ubicacion

#func _physics_process(delta):
#	movimiento(delta)
#
#func movimiento(delta):
#	pass
	
	

func _process(delta):
	match state:
		patrulla:
			_proceso_patrulla()
			anim_sprite()
		persecucion:
			_persecucion()
		retorno:
			_retornar()
			
	
	var motion = ubicacion.normalized() * speed * delta
	move_and_collide(motion)
#	global_position = Vector2(round(global_position.x), round(global_position.y))

func anim_sprite(): # Cambio de posicion de sprite en x and y
	if ubicacion.x != 0:
		mirar_x = true 
		if ubicacion.x > 0:
			$Sprite.flip_h = false
		elif ubicacion.x < 0:
			$Sprite.flip_h = true
		$anim.play("mov_x")

	elif ubicacion.y != 0:
		mirar_x = false
		if ubicacion.y > 0:
			$Sprite.flip_v = false
		elif ubicacion.y < 0:
			$Sprite.flip_v = true
		$anim.play("mov_y")
	elif ubicacion.x == 0 and ubicacion.y == 0:
		if !mirar_x:
			$anim.play("idle_y")
		else:
			$anim.play("idle_x")
	
func _proceso_patrulla():
	# Patrullaje en zig zag
#	if int(global_position.x) == (end_position.x  - 1) and llave < 1:
#		_ruta_aleatoria()
#
#	elif int(global_position.y) == (end_position.y - 1) and llave < 1:
#		_ruta_aleatoria()
	
	if rut_patrullaje:
		if global_position.x > end_position.x: # Si se pasa de end_position entonces regresa
			ubicacion.x -= 1
		
		elif global_position.x < end_position.x:
			ubicacion.x += 1
	
	elif !rut_patrullaje:
		if global_position.y > start_position.y + end_position.y:
			ubicacion.y -= 1
			
		elif global_position.y < start_position.y + end_position.y:
			ubicacion.y += 1
	
#	llave += 1
#	if llave == 2:
#		llave -= llave
	
func _ruta_aleatoria():
	randomize()
	var aleatorio = randi() % 1
	match aleatorio:
		0:
			rut_patrullaje = false
		1:
			rut_patrullaje = true
	
func _persecucion():
	ubicacion = Vector2.ZERO
	ubicacion = (player_node.position - position).normalized() * speed
	
func _retornar():
	ubicacion = Vector2.ZERO
	ubicacion = (last_position - position).normalized() * speed
	
	if Vector2(round(global_position.x), round(global_position.y)) == Vector2(round(last_position.x), round(last_position.y)):
		_ruta_reset()
		state = patrulla
	
# Funciones para seguir al Personaje y para dejar de seguirlo
func _on_areaVision_body_entered(body):
	if body.is_in_group("Jugador"):
		if state == patrulla: # Si el npc esta es estado patrulla
			last_position = global_position
		player_node = body
		state = persecucion # CAmbiamos el estado del npc a persecucion

func _on_areaVision_body_exited(body):
	if body.is_in_group("Jugador") and state == persecucion:
		state = retorno
		
func _ruta_reset():
	end_position = _copia_end_position
	ubicacion = _copia_ubicacion
