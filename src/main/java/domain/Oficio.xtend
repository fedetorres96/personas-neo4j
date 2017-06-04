package domain

import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.utils.Observable

@Observable
@Accessors
class Oficio {

	Long id
	
	String nombre

	int gradoDestreza = 1

	def void validar() {
		if (nombre.nullOrEmpty) {
			throw new Exception("Debe seleccionar un oficio")
		}

		if (gradoDestreza < 1 || gradoDestreza > 10) {
			throw new Exception("El grado de destreza debe ser entre 1 y 10")
		}
	}

	override toString() {
		nombre
	}

}
