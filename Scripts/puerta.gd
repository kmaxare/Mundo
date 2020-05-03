extends StaticBody2D

var estado_puerta = 0 # 0 abierto, 1 cerrado, 2 rota
export var num_puerta = 0

enum {abierto, cerrado, rota} # EStados de la puerta

var state

var casa_llena = false #Variable para identificar si el jugador esta dentro de la casa

func _ready():
	estado_puerta = get_parent().estado_puerta # Cuando arranque asignara la variable estado puerta del edificio a estado puerta de este script
	match estado_puerta:
		0:
			state = abierto # Se puede tener acceso a la estructura
		1:
			state = cerrado # No se puede acceder a la estructura
		2:
			state = rota # El portal de ingreso esta dañado y no se puede acceder

func abrir_puerta(): # Interaccion del jugador o npc con la puerta
	if state == abierto:
		$CollisionShape2D.disabled = true # Desactivamos colicion de bloqueo
		if !get_parent().get_node("casa_interior").visible: # Preguntamos si el sprite "casa_interior" no esta visible
			get_parent().get_node("casa_interior").visible = true  # Volvemos visible el sprite "Casa interior"
			get_tree().get_nodes_in_group("estado")[0].text = ("Estado: puerta abierta") # Informamos la accion
		elif get_parent().get_node("casa_interior").visible: # Identificamos si el jugador esta dentro de la casa
			casa_llena = true # Confirmamos que el jugador se encuentra dentro del edificio
		
	elif state == cerrado:
		get_tree().get_nodes_in_group("estado")[0].text = ("Estado: puerta Cerrada")
	elif state == rota:
		get_tree().get_nodes_in_group("estado")[0].text = ("Estado: puerta Dañada")

#Esta funcion identifica todos las coliciones que salen de la puerta
func _on_margen_puerta_body_exited(body):
	if body.is_in_group("person"): # Si la colicion es un personaje la reconoce para cerrar la puerta
		yield(get_tree().create_timer(0.1),"timeout") # Hacemos una pausa temporal para que la puerta se cierre otra ves
		if casa_llena: # Si el jugador se encuentra dentro del edificio permitimos desactivar el sprite "casa_interior"
			get_parent().get_node("casa_interior").visible = false
			casa_llena = false # La casa se vacia
		$CollisionShape2D.disabled = false # Reactivamos la colicion
