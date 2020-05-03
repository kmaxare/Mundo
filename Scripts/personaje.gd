extends KinematicBody2D

export var speed = 200


var distancia = Vector2()
var velocidad = Vector2()

var mirar_x = true # Variable para oreientar a donde mira el jugador

var direccion_x = 0
var direccion_y = 0

var obj_coll

# Acciones puerta
var puerta_true = false

func _ready():
	$anim.play("idleUno")
	
func _physics_process(delta):
	
	if $RayCast2D.is_colliding(): # Colicion con puerta
		obj_coll = $RayCast2D.get_collider()
		if obj_coll.is_in_group("Door"):
#		obj_coll = $RayCast2D.get_collider()
#		if obj_coll.is_in_group("Door"):
			get_tree().get_nodes_in_group("estado")[0].text = ("Estado: Puerta en frente")
			puerta_true = true
			
	else:
		get_tree().get_nodes_in_group("estado")[0].text = ("Estado:")
		puerta_true = false
					
	movimiento(delta)

func movimiento(delta):
	direccion_x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direccion_y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	sprite_and_Raycast()
	
	distancia.x = speed * delta
	velocidad.x = (direccion_x * distancia.x) / delta
	
	distancia.y = speed * delta
	velocidad.y = (direccion_y * distancia.y) / delta
	
	move_and_slide(velocidad, Vector2())
	
	if puerta_true:
		abrir_puerta()
	
func abrir_puerta():
	if Input.is_action_just_pressed("abrir_puerta"):
		obj_coll.abrir_puerta()

# Cambio de posicion de sprite en x and y - Adicional a eso cambio de pocicion de direccion del Raycast
func sprite_and_Raycast():
	if direccion_x != 0:
		mirar_x = true 
		if direccion_x > 0:
			$Sprite.flip_h = true
			$RayCast2D.rotation_degrees = -90
		elif direccion_x < 0:
			$Sprite.flip_h = false
			$RayCast2D.rotation_degrees = 90
		$anim.play("mov_x")
			
	elif direccion_y != 0:
		mirar_x = false
		if direccion_y > 0:
			$Sprite.flip_v = true
			$RayCast2D.rotation_degrees = 0
		elif direccion_y < 0:
			$Sprite.flip_v = false
			$RayCast2D.rotation_degrees = 180
		$anim.play("mov_y")
	elif direccion_x == 0 and direccion_y == 0:
		if !mirar_x:
			$anim.play("idleUno")
		else:
			$anim.play("idleDos")

func identificar_puerta():
	pass
