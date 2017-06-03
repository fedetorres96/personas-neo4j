package domain.utils

import domain.Oficio
import domain.Persona
import domain.Relacion
import org.neo4j.graphdb.Node
import org.neo4j.graphdb.Relationship

class NodeConverter {
	
	def static Persona toPersona(Node nodePersona, boolean deep) {
		var persona = new Persona => [
			id = nodePersona.id
			nombre = nodePersona.getProperty("nombre", "") as String
			fechaNacimiento = nodePersona.getProperty("fechaNacimiento", "") as String
		]
		
		if (deep) {
			
			val trabajaDe = nodePersona.getRelationships(RelacionesPersona.TRABAJA_DE)
			persona.oficios = trabajaDe.map[ endNode.toOficio ].toList
			
			val saleCon = nodePersona.getRelationships(RelacionesPersona.SALE_CON)
			persona.relaciones = saleCon.map[ toRelacion ].toList
			
		}
		
		persona
	}
	
	def static Oficio toOficio(Node nodeOficio) {
		new Oficio => [
			nombre = nodeOficio.getProperty("nombre", "") as String
		]
	}
	
	def static Relacion toRelacion(Relationship relacionSaleCon) {
		new Relacion => [
			persona = relacionSaleCon.endNode.toPersona(false)
			esFiel = relacionSaleCon.getProperty("esFiel", false) as Boolean
		]
	}
	
}