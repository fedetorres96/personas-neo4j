package repos

import domain.Persona
import java.util.Iterator
import java.util.List
import org.neo4j.graphdb.Label
import org.neo4j.graphdb.Node

import static extension domain.utils.NodeConverter.*

class RepoPersonas extends RepoNeo4J<Persona> {

	def void saveOrUpdate(Persona persona) {
		val transaction = graphDb.beginTx
		try {
			var Node nodoPersona = null

			if (persona.id == null) {
				nodoPersona = graphDb.createNode
				nodoPersona.addLabel(label)
			} else {
				nodoPersona = graphDb.getNodeById(persona.id)
			}

			updatePersona(persona, nodoPersona)
			transaction.success

			persona.id = nodoPersona.id
		} finally {
			cerrarTransaccion(transaction)
		}
	}

	def Persona getByExample(Persona persona) {
		val transaction = graphDb.beginTx
		var Persona entity = null
		try {
			var Node nodoPersona = null

			nodoPersona = graphDb.getNodeById(persona.id)
			entity = nodoPersona.toPersona(true)

			transaction.success

		} finally {
			cerrarTransaccion(transaction)
		}

		entity
	}

	def List<Persona> searchByExample(Persona persona) {
		val transaction = graphDb.beginTx
		var personas = newArrayList
		
		try {
			
			val params = "p.nombre = '" + persona.nombre + "' AND p.fechaNacimiento = '" + persona.fechaNacimiento + "'"
			val nodos = basicSearch(params)
			personas.addAll(nodos.asList)
			
			transaction.success
		} finally {
			cerrarTransaccion(transaction)
		}
		
		personas
	}

	def Iterator<Node> basicSearch(String where) {
		graphDb.execute("match (p:Persona) where " + where + " return p").columnAs("p")
	}

	def void updatePersona(Persona persona, Node nodePersona) {
		nodePersona => [
			setProperty("nombre", persona.nombre)
			setProperty("fechaNacimiento", persona.fechaNacimiento)
		]

	}

	override label() {
		Label.label("Persona")
	}

	override asList(Iterator<Node> nodos) {
		nodos.map[toPersona(false)].toList
	}

}
