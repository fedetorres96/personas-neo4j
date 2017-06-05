package repos

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
			persona.oficios = trabajaDe.map[toOficio].toList

			val saleCon = nodePersona.getRelationships(RelacionesPersona.SALE_CON)
			persona.relaciones = saleCon.map[toRelacion(nodePersona)].toList
		}

		persona
	}

	def static Oficio toOficio(Node nodeOficio) {
		new Oficio => [
			id = nodeOficio.id
			nombre = nodeOficio.getProperty("nombre") as String
		]
	}

	def static Oficio toOficio(Relationship relacionOficio) {
		val nodoOficio = relacionOficio.endNode
		
		new Oficio => [
			id = nodoOficio.id
			nombre = nodoOficio.getProperty("nombre") as String
			gradoDestreza = (relacionOficio.getProperty("gradoDestreza", 0) as Long).intValue
		]
	}

	def static Relacion toRelacion(Relationship relacionSaleCon, Node nodoPersona) {
		val nodoOtraPersona = relacionSaleCon.getOtherNode(nodoPersona)
		val fidelidad = relacionSaleCon.getProperty("esFiel", false) as Boolean
		val startNode = relacionSaleCon.startNode
		
		new Relacion => [
			persona = nodoOtraPersona.toPersona(false)
			esFiel = if ( startNode.equals(nodoPersona) ) fidelidad else true
		]
	}

}
