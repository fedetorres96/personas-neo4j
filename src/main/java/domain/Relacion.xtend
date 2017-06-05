package domain

import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.utils.Observable

@Observable
@Accessors
class Relacion {
	
//	Long id
	
	Persona persona
	
	boolean esFiel = false
	
	def void validar(){
		if ( persona == null ){
			throw new Exception("No podés salir con null")
		}
	}
	
}