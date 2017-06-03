package domain

import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.utils.Observable

@Observable
@Accessors
class Relacion {
	
	Persona persona
	
	boolean esFiel = false
	
	def void validar(){
		if ( persona == null ){
			throw new Exception("Debe seleccionar una persona")
		}
	}
	
}