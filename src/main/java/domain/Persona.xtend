package domain

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.LocalDate
import org.joda.time.format.DateTimeFormat
import org.uqbar.commons.utils.Observable

@Observable
@Accessors
class Persona {

	Long id

	String nombre = ""

	String fechaNacimiento = ""

	List<Oficio> oficios = newArrayList

	List<Relacion> relaciones = newArrayList

	def void validar() {
		if (nombre.nullOrEmpty)
			throw new Exception("El nombre no puede estar vacío")

		val fechaHoy = new LocalDate
		val fechaNacimiento = DateTimeFormat.forPattern("dd/MM/yyyy").parseLocalDate(fechaNacimiento)

		if (fechaNacimiento > fechaHoy)
			throw new Exception("La fecha de nacimiento no puede ser futura")
	}
	
	override toString(){
		nombre
	}

}
