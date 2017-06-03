package arena

import domain.Oficio
import domain.Persona
import domain.Relacion
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.UserException
import org.uqbar.commons.utils.ApplicationContext
import org.uqbar.commons.utils.Observable
import repos.RepoOficios
import repos.RepoPersonas

@Observable
@Accessors
class PersonasModel {
	RepoPersonas repoPersonas
	RepoOficios repoOficios

	List<Persona> personas
	List<Persona> relaciones
	List<Oficio> oficios

	Persona personaSeleccionada
	String nombre
	String fecha

	Oficio oficioSeleccionado
	Oficio nuevoOficio

	Relacion relacionSeleccionada
	Relacion nuevaRelacion

	new() {
		repoPersonas = ApplicationContext.instance.getSingleton(RepoPersonas)
		repoOficios = ApplicationContext.instance.getSingleton(RepoOficios)
		cargarPersonas
		cargarOficios
	}

	def cargarPersonas() {
		personas = repoPersonas.allInstances
		relaciones = repoPersonas.allInstances
		personaSeleccionada = new Persona
		initRelacion
	}

	def cargarOficios() {
		oficios = repoOficios.allInstances
		initOficio
	}

	def actualizarPersona() {
		try {
			personaSeleccionada.nombre = nombre
			personaSeleccionada.fechaNacimiento = fecha
			personaSeleccionada.validar
			repoPersonas.saveOrUpdate(personaSeleccionada)
		} catch (Exception e) {
			throw new UserException(e.message)
		} finally {
			cargarPersonas
		}
	}

	def void buscarPersona() {
		val example = new Persona => [
			it.nombre = nombre
			fechaNacimiento = fecha
		]
		personas = repoPersonas.searchByExample(example)
	}

	def void setPersonaSeleccionada(Persona persona) {
		if (persona != null) {
			personaSeleccionada = repoPersonas.getByExample(persona)
			nombre = persona.nombre
			fecha = persona.fechaNacimiento
		} else {
			personaSeleccionada = null
			nombre = ""
			fecha = ""
		}
	}

	def void agregarOficio() {
		try {
			validar
			nuevoOficio.validar
			personaSeleccionada.oficios.add(nuevoOficio)
			initOficio
		} catch (Exception e) {
			throw new UserException(e.message)
		}
	}

	def void eliminarOficio() {
		personaSeleccionada.oficios.remove(oficioSeleccionado)
	}

	def void agregarRelacion() {
		try {
			validar
			nuevaRelacion.validar
			personaSeleccionada.relaciones.add(nuevaRelacion)
			initRelacion
		} catch (Exception e) {
			throw new UserException(e.message)
		}
	}

	def void eliminarRelacion() {
		personaSeleccionada.relaciones.remove(relacionSeleccionada)
	}

	def void initRelacion() {
		nuevaRelacion = new Relacion
	}

	def void initOficio() {
		nuevoOficio = new Oficio
	}

	def void validar() {
		if (personaSeleccionada == null) {
			throw new Exception("Debes seleccionar una persona")
		}
	}
}
