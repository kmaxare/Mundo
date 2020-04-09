extends KinematicBody2D

export var speed = 200


var distancia = Vector2()
var velocidad = Vector2()

var mirar_x = true # Variable para oreientar a donde mira el jugador

var direccion_x = 0
var direccion_y = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$anim.play("idleUno")
	
func _physics_process(delta):
	movimiento(delta)

func movimiento(delta):
	direccion_x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	direccion_y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	sprite()
	
	distancia.x = speed * delta
	velocidad.x = (direccion_x * distancia.x) / delta
	
	distancia.y = speed * delta
	velocidad.y = (direccion_y * distancia.y) / delta
	
	move_and_slide(velocidad, Vector2())

func sprite(): # Cambio de posicion de sprite en x and y
	if direccion_x != 0:
		mirar_x = true 
		if direccion_x > 0:
			$Sprite.flip_h = true
		elif direccion_x < 0:
			$Sprite.flip_h = false
		$anim.play("mov_x")
			
	elif direccion_y != 0:
		mirar_x = false
		if direccion_y > 0:
			$Sprite.flip_v = true
		elif direccion_y < 0:
			$Sprite.flip_v = false
		$anim.play("mov_y")
	elif direccion_x == 0 and direccion_y == 0:
		if !mirar_x:
			$anim.play("idleUno")
		else:
			$anim.play("idleDos")
	
