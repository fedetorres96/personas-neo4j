package arena

import domain.Oficio
import domain.Persona
import domain.Relacion
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
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

		initParams
	}

	def cargarPersonas() {
		personas = repoPersonas.allInstances
		relaciones = repoPersonas.allInstances
		initRelacion
	}

	def void actualizarPersona() {
		if ( personaSeleccionada == null ){
			personaSeleccionada = new Persona
		}
		
		personaSeleccionada => [
			it.nombre = nombre
			it.fechaNacimiento = fecha
			it.validar
		]

		updatePersona
		cargarPersonas
	}

	def void buscarPersona() {
		val example = new Persona => [
			it.nombre = nombre
			it.fechaNacimiento = fecha
		]

		personas = repoPersonas.searchByExample(example)
		
		personaSeleccionada = null
	}

	def void setPersonaSeleccionada(Persona persona) {
		if (persona != null) {
			personaSeleccionada = repoPersonas.getByExample(persona)
			nombre = persona.nombre
			fecha = persona.fechaNacimiento
		} else {
			personaSeleccionada = null
			initParams
		}
	}

	def void agregarOficio() {
		nuevoOficio.validar
		personaSeleccionada.addOficio(nuevoOficio)
		
		updatePersona
	}

	def void eliminarOficio() {
		personaSeleccionada.removeOficio(oficioSeleccionado)
		
		updatePersona
	}

	def void agregarRelacion() {
		nuevaRelacion.validar
		personaSeleccionada.addRelacion(nuevaRelacion)
		
		updatePersona
	}

	def void eliminarRelacion() {
		personaSeleccionada.removeRelacion(relacionSeleccionada)
		
		updatePersona
	}

	def void initRelacion() {
		nuevaRelacion = new Relacion
	}

	def void initOficio() {
		nuevoOficio = new Oficio
	}

	def void initParams() {
		nombre = ""
		fecha = ""
	}

	def void updatePersona() {
		repoPersonas.saveOrUpdate(personaSeleccionada)
		firePropertyChanged(this, "personaSeleccionada")
	}
}
