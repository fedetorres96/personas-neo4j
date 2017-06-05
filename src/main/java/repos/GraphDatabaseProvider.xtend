package repos

import java.io.File
import org.eclipse.xtend.lib.annotations.Accessors
import org.neo4j.graphdb.GraphDatabaseService
import org.neo4j.graphdb.factory.GraphDatabaseFactory

@Accessors
class GraphDatabaseProvider {
	static String PATH = "/var/lib/neo4j/data/databases/graph.db"
	static GraphDatabaseProvider instance
	
	GraphDatabaseService graphDb
	
	private new() {
		graphDb = new GraphDatabaseFactory().newEmbeddedDatabase(new File(PATH))
	}
	
	def static instance() {
		if (instance == null) {
			instance = new GraphDatabaseProvider		
		}
		
		instance
	}	 	
}