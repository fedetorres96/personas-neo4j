package repos

import java.util.Iterator
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.graphdb.GraphDatabaseService
import org.neo4j.graphdb.Label
import org.neo4j.graphdb.Node
import org.neo4j.graphdb.Transaction

@Accessors
abstract class RepoNeo4J<T> {
	
	GraphDatabaseService graphDb = GraphDatabaseProvider.instance.graphDb

	def List<T> allInstances() {
		val transaction = openTransaction
		var List<T> entities = newArrayList
		
		try {
			entities.addAll(getNodos.asList)
			transaction.success
		} finally {
			transaction.close
		}
		
		entities
	}
	
	def Iterator<Node> getNodos(){
		graphDb.execute("match (n:"+ label +") return n").columnAs("n")
	}
	
	def Iterator<Node> getNodosBy(String where) {
		graphDb.execute("match (n:"+ label +") where " + where + " return n").columnAs("n")
	}
	
	def List<T> asList ( Iterator<Node> nodos )
	
	def Label label()
	
	def Transaction openTransaction(){
		graphDb.beginTx
	}
}