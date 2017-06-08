package repos

import domain.Persona
import java.util.Iterator
import java.util.List
import org.neo4j.graphdb.Label
import org.neo4j.graphdb.Node

import static extension repos.NodeConverter.*

class RepoPersonas extends RepoNeo4J<Persona> {

	def void saveOrUpdate(Persona persona) {
		val transaction = openTransaction
		
		try {
			var Node nodoPersona = null

			if (persona.id == null) {
				nodoPersona = graphDb.createNode(label)
				persona.id = nodoPersona.id
			} else {
				nodoPersona = graphDb.getNodeById(persona.id)
			}

			updatePersona(persona, nodoPersona)
			transaction.success
		} finally {
			transaction.close
		}
	}

	def Persona getByExample(Persona persona) {
		val transaction = openTransaction
		var Persona entity = null
		
		try {
			var Node nodoPersona = null

			nodoPersona = graphDb.getNodeById(persona.id)
			entity = nodoPersona.toPersona(true)

			transaction.success
		} finally {
			transaction.close
		}

		entity
	}

	def List<Persona> searchByExample(Persona persona) {
		val transaction = openTransaction
		var personas = newArrayList
		
		try {
			val params = "n.nombre = '" + persona.nombre + "' OR n.fechaNacimiento = '" + persona.fechaNacimiento + "'"
			val nodos = getNodosBy(params)
			personas.addAll(nodos.asList)
			
			transaction.success
		} finally {
			transaction.close
		}
		
		personas
	}

	def void updatePersona(Persona persona, Node nodePersona) {
		nodePersona => [
			setProperty("nombre", persona.nombre)
			setProperty("fechaNacimiento", persona.fechaNacimiento)
			
			getRelationships(RelacionesPersona.TRABAJA_DE).forEach[it.delete]
			
			persona.oficios.forEach[oficio |
				val Node nodoOficio = graphDb.getNodeById(oficio.id)
				nodePersona.createRelationshipTo(nodoOficio, RelacionesPersona.TRABAJA_DE)
				.setProperty("gradoDestreza", oficio.gradoDestreza as long)
			]
			
			getRelationships(RelacionesPersona.SALE_CON).forEach[it.delete]
			
			persona.relaciones.forEach[relacion |
				val Node nodoRelacion = graphDb.getNodeById(relacion.persona.id)
				nodePersona.createRelationshipTo(nodoRelacion, RelacionesPersona.SALE_CON)
				.setProperty("esFiel", relacion.esFiel as boolean)
			]
		]
	}
	
	override label() {
		Label.label("Persona")
	}

	override asList(Iterator<Node> nodos) {
		nodos.map[toPersona(false)].toList
	}

}
