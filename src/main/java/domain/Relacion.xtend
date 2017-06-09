package domain

import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.utils.Observable

import static helpers.ErrorHelper.*

@Observable
@Accessors
class Relacion {

	Persona persona

	boolean esFiel = false

	def void validar() {
		mostrarError(persona == null, "No podés salir con null")
	}

}
