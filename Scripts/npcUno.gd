extends KinematicBody2D

# Variables para el movimiento del personaje
export var speed = 10
export var distancia = 50 # Distancia que recorrera en x and y el NPC
export var rut_patrullaje = true # Direccion de patrulla false (arriba, abajo), true (derecha, izquierda)

var ubicacion = Vector2()
var mirar_x = true # Variable para oreientar a donde mira el jugador

# Variable para el patrullaje de el npc
var start_position = Vector2() # Ubicacion actual
var end_position = Vector2(0, 0) # Rango de distancia que rrecore npc

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
	
func _physics_process(delta):
	movimiento(delta)

func movimiento(delta):
	_proceso_patrulla()
	anim_sprite()
	
	var motion = ubicacion.normalized() * speed * delta
	move_and_collide(motion)

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
		if position.x > end_position.x: # Si se pasa de end_position entonces regresa
			ubicacion.x -= 1
		
		elif position.x < end_position.x:
			ubicacion.x += 1
	
	elif !rut_patrullaje:
		if position.y > start_position.y + end_position.y:
			ubicacion.y -= 1
			
		elif position.y < start_position.y + end_position.y:
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
	pass
	
func _retornar():
	pass
	
# Funciones para seguir al Personaje y para dejar de seguirlo
func _on_areaVision_body_entered(body):
#	print ("ese man es un tipaso")
	pass

func _on_areaVision_body_exited(body):
#	print ("ya se fue")
	pass
