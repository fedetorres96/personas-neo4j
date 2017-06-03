package repos

import domain.Oficio
import java.util.Iterator
import org.neo4j.graphdb.Label
import org.neo4j.graphdb.Node

import static extension domain.utils.NodeConverter.*

class RepoOficios extends RepoNeo4J<Oficio> {

	override label() {
		Label.label("Oficio")
	}
	
	override asList(Iterator<Node> nodos) {
		nodos.map[toOficio].toList
	}

}
