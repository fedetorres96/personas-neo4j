package domain

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.LocalDate
import org.joda.time.format.DateTimeFormat
import org.uqbar.commons.utils.Observable
import helpers.ErrorHelper

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

		val LocalDate fechaHoy = new LocalDate

		ErrorHelper.capturarError("La fecha de nacimiento no tiene un formato válido",[ fechaNacimientoLocalDate ])

		if (fechaNacimientoLocalDate > fechaHoy)
			throw new Exception("La fecha de nacimiento no puede ser futura")
	}
	
	def fechaNacimientoLocalDate(){
		return DateTimeFormat.forPattern("dd/MM/yyyy").parseLocalDate(fechaNacimiento);
	}
	
	def void validarSeleccionado(){
		ErrorHelper.capturarError("El usuario no fue seleccionado",[validar]);
	}

	override toString() {
		nombre
	}

}
