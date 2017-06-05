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
import static org.uqbar.commons.model.ObservableUtils.*

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

		oficios = repoOficios.allInstances
		initOficio
	}

	def cargarPersonas() {
		personas = repoPersonas.allInstances
		relaciones = repoPersonas.allInstances
		personaSeleccionada = new Persona
		initRelacion
	}

	def void actualizarPersona() {
		try {
			personaSeleccionada => [
				it.nombre = nombre
				it.fechaNacimiento = fecha
				it.validar
			]
			
			repoPersonas.saveOrUpdate(personaSeleccionada)
			
			cargarPersonas
		} catch (Exception e) {
			throw new UserException(e.message)
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
			personaSeleccionada => [
				it.oficios.add(nuevoOficio)
			]
			repoPersonas.saveOrUpdate(personaSeleccionada)
			firePropertyChanged(this, "personaSeleccionada")
		} catch (Exception e) {
			throw new UserException(e.message)
		}
	}

	def void eliminarOficio() {
		// TODO
	}

	def void agregarRelacion() {
		// TODO
	}

	def void eliminarRelacion() {
		// TODO
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
