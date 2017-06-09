package repos

import domain.Oficio
import java.util.Iterator
import org.neo4j.graphdb.Label
import org.neo4j.graphdb.Node

import static extension repos.NodeConverter.*

class RepoOficios extends RepoNeo4J<Oficio> {
	
	override saveOrUpdate(Oficio oficio) {
		val transaction = openTransaction

		try {
			var Node nodoOficio = null

			if (oficio.id == null) {
				nodoOficio = graphDb.createNode(label)
				oficio.id = nodoOficio.id
			} else {
				nodoOficio = getNodoById(oficio.id)
			}

			nodoOficio.setProperty("nombre", oficio.nombre)

			transaction.success
		} finally {
			transaction.close
		}
	}
	
	override label() {
		Label.label("Oficio")
	}
	
	override asList(Iterator<Node> nodos) {
		nodos.map[toOficio].toList
	}

}

