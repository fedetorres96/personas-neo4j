package repos

import domain.Persona
import java.util.Iterator
import org.neo4j.graphdb.Label
import org.neo4j.graphdb.Node

import static extension domain.utils.NodeConverter.*
import java.util.List

class RepoPersonas extends RepoNeo4J<Persona> {

	def void saveOrUpdate(Persona persona) {
		val transaction = graphDb.beginTx
		try {
			var Node nodoPersona = null

			if (persona.id == null) {
				nodoPersona = graphDb.createNode
				nodoPersona.addLabel(label)
			} else {
				nodoPersona = getNodoPersona(persona.id)
			}

			updatePersona(persona, nodoPersona)
			transaction.success

			persona.id = nodoPersona.id
		} finally {
			cerrarTransaccion(transaction)
		}
	}

	def Node getNodoPersona(Long id) {
		basicSearch("ID(p) = " + id).head
	}

	def List<Persona> searchByExample(Persona persona) {
		val params = "p.nombre = '" + persona.nombre + "' AND p.fechaNacimiento = '" + persona.fechaNacimiento + "'"
		val nodos = basicSearch(params)
		nodos.asList
	}

	def Iterator<Node> basicSearch(String where) {
		graphDb.execute("match (p:Persona) where " + where + " return p").columnAs("p")
	}

	def void updatePersona(Persona persona, Node nodePersona) {
		nodePersona => [
			setProperty("nombre", persona.nombre)
			setProperty("fechaNacimiento", persona.fechaNacimiento)
			relationships.forEach[delete]
		]
	}

	override label() {
		Label.label("Persona")
	}

	override asList(Iterator<Node> nodos) {
		nodos.map[toPersona].toList
	}

}
