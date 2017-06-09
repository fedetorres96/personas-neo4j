package domain

import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.joda.time.LocalDate
import org.joda.time.format.DateTimeFormat
import org.uqbar.commons.utils.Observable

import static helpers.ErrorHelper.*

@Observable
@Accessors
class Persona {

	Long id

	String nombre = ""

	String fechaNacimiento = ""

	List<Oficio> oficios = newArrayList

	List<Relacion> relaciones = newArrayList

	def void validar() {
		mostrarError(nombre.nullOrEmpty, "El nombre no puede estar vacío")

		val formatter = DateTimeFormat.forPattern("dd/MM/yyyy")

		capturarError([formatter.parseLocalDate(fechaNacimiento)], "La fecha de nacimiento no tiene un formato válido")

		val fechaHoy = new LocalDate
		val fechaNacimiento = formatter.parseLocalDate(fechaNacimiento)

		mostrarError(fechaNacimiento > fechaHoy, "La fecha de nacimiento no puede ser futura")
	}

	def void addOficio(Oficio oficio) {
		val example = oficios.findFirst[it.id == oficio.id]

		mostrarError(example != null, "Ya realiza ese oficio")

		oficios.add(oficio)
	}

	def void removeOficio(Oficio oficio) {
		val example = oficios.findFirst[it.id == oficio.id]

		mostrarError(example == null, "No realiza ese oficio")

		oficios.remove(oficio)
	}

	def void addRelacion(Relacion relacion) {
		val idPersona = relacion.persona.id
		val example = relaciones.findFirst[persona.id == idPersona]

		mostrarError(example != null, "Ya sale con esa persona")

		mostrarError(id == idPersona, "No puede salir con si mismo")

		relaciones.add(relacion)
	}

	def void removeRelacion(Relacion relacion) {
		val idPersona = relacion.persona.id
		val example = relaciones.findFirst[persona.id == idPersona]

		mostrarError(example == null, "No sale con esa persona")

		relaciones.remove(relacion)
	}

	override toString() {
		nombre
	}

}
