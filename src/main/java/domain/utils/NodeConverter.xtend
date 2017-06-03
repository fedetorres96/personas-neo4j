package domain.utils

import domain.Persona
import org.neo4j.graphdb.Node
import domain.Oficio

class NodeConverter {
	
	def static Persona toPersona(Node nodePersona) {
		new Persona => [
			id = nodePersona.id
			nombre = nodePersona.getProperty("nombre", "") as String
			fechaNacimiento = nodePersona.getProperty("fechaNacimiento", "") as String
		]
	}
	
	def static Oficio toOficio(Node nodeOficio) {
		new Oficio => [
			nombre = nodeOficio.getProperty("nombre", "") as String
		]
	}
	
}