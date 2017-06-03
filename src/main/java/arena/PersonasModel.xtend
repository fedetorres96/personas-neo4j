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
import org.uqbar.commons.model.UserException

@Observable
@Accessors
class PersonasModel {
	RepoPersonas repoPersonas
	RepoOficios repoOficios

	List<Persona> personas
	List<Oficio> oficios

	Persona personaSeleccionada

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
		personaSeleccionada = new Persona
		initRelacion
	}

	def cargarOficios() {
		oficios = repoOficios.allInstances
		initOficio
	}

	def actualizarPersona() {
		try {
			personaSeleccionada.validar
			repoPersonas.saveOrUpdate(personaSeleccionada)
		} catch (Exception e) {
			throw new UserException(e.message)
		} finally {
			cargarPersonas
		}
	}
	
	def void buscarPersona(){
		personas = repoPersonas.searchByExample(personaSeleccionada)
	}

	def void agregarOficio() {
		try {
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

}
