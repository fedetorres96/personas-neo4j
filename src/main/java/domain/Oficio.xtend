package domain

import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.utils.Observable

import static helpers.ErrorHelper.*

@Observable
@Accessors
class Oficio {

	Long id

	String nombre

	int gradoDestreza = 1

	def void validar() {
		mostrarError(nombre.nullOrEmpty, "Debe seleccionar un oficio")

		mostrarError(gradoDestreza < 1 || gradoDestreza > 10, "El grado de destreza debe ser entre 1 y 10")
	}

	override toString() {
		nombre
	}

}
