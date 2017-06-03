package repos

import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.graphdb.GraphDatabaseService
import org.neo4j.graphdb.Transaction
import java.util.List
import org.neo4j.graphdb.Label
import org.neo4j.graphdb.Node
import java.util.Iterator

@Accessors
abstract class RepoNeo4J<T> {
	
	GraphDatabaseService graphDb = GraphDatabaseProvider.instance.graphDb

	def void cerrarTransaccion(Transaction transaction) {
		if (transaction != null) {
			transaction.close
		}
	}
	
	def List<T> allInstances() {
		val transaction = graphDb.beginTx
		try {
			nodos.asList
		} finally {
			cerrarTransaccion(transaction)
		}
	}
	
	def Iterator<Node> getNodos(){
		graphDb.execute("match (e:"+ label +") return e").columnAs("e")
	}
	
	def List<T> asList ( Iterator<Node> nodos )
	
	def Label label()
}