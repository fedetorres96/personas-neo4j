package repos

import domain.Oficio
import java.util.Iterator
import org.neo4j.graphdb.Label
import org.neo4j.graphdb.Node

import static extension domain.utils.NodeConverter.*
import java.util.List

class RepoOficios extends RepoNeo4J<Oficio> {

	def void saveOrUpdate(Oficio oficio) {
		val transaction = graphDb.beginTx
		try {
			var Node nodoOficio = null

			if (oficio.id == null) {
				nodoOficio = graphDb.createNode
				nodoOficio.addLabel(label)
			} else {
				nodoOficio = graphDb.getNodeById(oficio.id)
			}

			updateOficio(oficio, nodoOficio)
			transaction.success

			oficio.id = nodoOficio.id
		} finally {
			cerrarTransaccion(transaction)
		}
	}
	
	def Oficio getByExample(Oficio oficio) {
		val transaction = graphDb.beginTx
		var Oficio entity = null
		try {
			var Node nodoOficio = null

			nodoOficio = graphDb.getNodeById(oficio.id)
			entity = nodoOficio.toOficio//(true)

			transaction.success

		} finally {
			cerrarTransaccion(transaction)
		}

		entity
	}
	
	def List<Oficio> searchByExample(Oficio oficio) {
		val transaction = graphDb.beginTx
		var oficios = newArrayList
		
		try {
			
			val params = "p.nombre = '" + oficio.nombre + "' AND p.gradoDestreza = '" + oficio.gradoDestreza + "'"
			val nodos = basicSearch(params)
			oficios.addAll(nodos.asList)
			
			transaction.success
		} finally {
			cerrarTransaccion(transaction)
		}
		
		oficios
	}
	
	def Iterator<Node> basicSearch(String where) {
		graphDb.execute("match (p:Oficio) where " + where + " return p").columnAs("p")
	}

	def updateOficio(Oficio oficio, Node nodeOficio) {
			nodeOficio => [
			setProperty("nombre", oficio.nombre)
			setProperty("fechaNacimiento", oficio.gradoDestreza)
		]
	}
	
	
	override label() {
		Label.label("Oficio")
	}
	
	override asList(Iterator<Node> nodos) {
		nodos.map[toOficio].toList
	}

}

