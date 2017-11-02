class EstaminaInsuficienteException inherits Exception
class EmpleadoNoTieneLasHerramientasException inherits Exception
class FuerzaInsuficienteException inherits Exception

class Empleado{
	var rol
	var estamina
	var tareasRealizadas

	method comerFruta(puntosQueRecupera) {
		estamina += puntosQueRecupera
	}

	method experiencia() = tareasRealizadas.sum({tarea => tarea.dificultad()}) * tareasRealizadas.size()

	method asignarRol(_rol) {
		rol = _rol
	}

	method realizarTarea(tarea) {
		if(tarea.puedeSerRealizadaPor(self)){
			tareasRealizadas.add(tarea)
			tarea.realizadaPor(self)
		}
	}

	method tieneHerramienta(herramienta) {
		rol.tieneHerramienta(herramienta)
	}

	method estamina() = estamina

	method disminuirEstamina(cantidad) {
		estamina -= cantidad
	}

	method fuerza() =  (estamina/2)+ 2 + rol.factorFuerza()
	
}

class Obrero {
	var herramientas

	method tieneHerramienta(herramienta) = herramientas.contains(herramienta)

	method factorFuerza() = 0
}

class Soldado {

	var danioQueCausa = 0
	method tieneHerramienta(herramienta) = false
	method factorFuerza() = danioQueCausa

}

class Mucama {

	method tieneHerramienta(herramienta) = false
	method factorFuerza() = 0
}

class Ciclope inherits Empleado {
	const cantidadOjos = 1

	override method fuerza() = super()/2
}

class Biclope inherits Empleado {
	const cantidadOjos = 2
}

class ArreglarMaquina{
	var complejidad
	var herramientasRequeridas
	
	method puedeSerRealizadaPor(empleado) {
		if(empleado.estamina() < complejidad){
			throw new EstaminaInsuficienteException()
		}

		if(!herramientas.all({herramienta => empleado.tieneHerramienta(herramienta)})){
			throw new EmpleadoNoTieneLasHerramientasException()
		}

		return true
	}

	method  esRealizadaPor(empleado) {
		empleado.disminuirEstamina(complejidad)
	}

	method dificultad() = 2 * complejidad
}

class DefenderSector {
	var gradoFuerza
	var empleadoQueRealiza

	method dificultad() {
		if(empleadoQueRealiza.cantidadOjos() == 1){
			return 2*gradoFuerza
		}
		return gradoFuerza		
	}

	method puedeSerRealizadaPor(empleado) {
		if(empleado.fuerza() < gradoFuerza){
			throw new FuerzaInsuficienteException()
		}

		return true
	}
}

class LimpiarSector {
	var dificultad = 10

	method dificultad(_dificultad) {
		dificultad = _dificultad
	}

	method dificultad() = dificultad
}
