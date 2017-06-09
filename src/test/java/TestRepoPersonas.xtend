import domain.Oficio
import domain.Persona
import domain.Relacion
import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.neo4j.graphdb.GraphDatabaseService
import org.neo4j.test.TestGraphDatabaseFactory
import org.uqbar.commons.model.UserException
import repos.RepoOficios
import repos.RepoPersonas

class TestRepoPersonas {
	RepoPersonas personas
	RepoOficios oficios
	GraphDatabaseService graphDb

	Persona diego
	Persona rocio
	Persona veronica

	Oficio jugador
	Oficio botinera

	@Before
	def void init() {
		graphDb = new TestGraphDatabaseFactory().newImpermanentDatabase();

		personas = new RepoPersonas
		oficios = new RepoOficios
		
		personas.graphDb = graphDb
		oficios.graphDb = graphDb
		
		diego = new Persona => [
			nombre = "Diego"
		]

		rocio = new Persona => [
			nombre = "Rocìo"
		]

		veronica = new Persona => [
			nombre = "Verónica"
		]

		jugador = new Oficio => [
			nombre = "Jugador"
		]

		botinera = new Oficio => [
			nombre = "Botinera"
		]

		personas.saveOrUpdate(diego)
		personas.saveOrUpdate(rocio)
		personas.saveOrUpdate(veronica)

		oficios.saveOrUpdate(jugador)
		oficios.saveOrUpdate(botinera)
	}

	@After
	def void after() {
		graphDb.shutdown
	}

	@Test
	def void lasEntidadesSeCarganEnElGrafo() {
		Assert.assertTrue(diego.id != null)
		Assert.assertTrue(rocio.id != null)
		Assert.assertTrue(veronica.id != null)

		Assert.assertTrue(jugador.id != null)
		Assert.assertTrue(botinera.id != null)
	}

	@Test
	def void seActulizaInfoDeDiego() {
		var diegoDB = personas.getByExample(diego)

		Assert.assertEquals("Diego", diegoDB.nombre)
		Assert.assertEquals("", diegoDB.fechaNacimiento)

		diego => [
			nombre = "Diego Armando Maradona"
			fechaNacimiento = "30/10/1960"
		]

		personas.saveOrUpdate(diego)

		diegoDB = personas.getByExample(diego)

		Assert.assertEquals("Diego Armando Maradona", diegoDB.nombre)
		Assert.assertEquals("30/10/1960", diegoDB.fechaNacimiento)
	}

	@Test
	def void diegoEsJugador() {
		jugador.gradoDestreza = 10
		diego.addOficio(jugador)
		personas.saveOrUpdate(diego)

		val diegoDB = personas.getByExample(diego)

		Assert.assertEquals(1, diegoDB.oficios.size)
	}

	@Test
	def void rocioYaNoEsBotinera() {
		botinera.gradoDestreza = 7
		veronica.addOficio(botinera)
		personas.saveOrUpdate(veronica)

		var veronicaDB = personas.getByExample(veronica)

		Assert.assertEquals(1, veronicaDB.oficios.size)

		veronica.removeOficio(botinera)
		personas.saveOrUpdate(veronica)

		veronicaDB = personas.getByExample(veronica)

		Assert.assertEquals(0, veronicaDB.oficios.size)
	}

	@Test
	def void diegoSaleConVeronicaYRocio() {
		val saleConVeronica = new Relacion => [
			persona = veronica
			esFiel = true
		]

		val saleConRocio = new Relacion => [
			persona = rocio
			esFiel = true
		]

		diego.addRelacion(saleConVeronica)
		diego.addRelacion(saleConRocio)

		personas.saveOrUpdate(diego)

		val diegoDB = personas.getByExample(diego)

		Assert.assertEquals(2, diegoDB.relaciones.size)

		val veronicaDB = personas.getByExample(veronica)

		Assert.assertEquals(1, veronicaDB.relaciones.size)

		val rocioDB = personas.getByExample(rocio)

		Assert.assertEquals(1, rocioDB.relaciones.size)
	}

	@Test
	def void diegoYaNoSaleConVeronica() {
		val saleConVeronica = new Relacion => [
			persona = veronica
			esFiel = true
		]

		diego.addRelacion(saleConVeronica)
		personas.saveOrUpdate(diego)

		var diegoDB = personas.getByExample(diego)

		Assert.assertEquals(1, diegoDB.relaciones.size)

		var veronicaDB = personas.getByExample(veronica)

		Assert.assertEquals(1, veronicaDB.relaciones.size)

		diego.removeRelacion(saleConVeronica)
		personas.saveOrUpdate(diego)

		diegoDB = personas.getByExample(diego)

		Assert.assertEquals(0, diegoDB.relaciones.size)

		veronicaDB = personas.getByExample(veronica)

		Assert.assertEquals(0, veronicaDB.relaciones.size)
	}
	
	
	@Test(expected=UserException)
	def void rocioYaEsBotinera() {
		veronica.addOficio(botinera)
		veronica.addOficio(botinera)
	}

	@Test(expected=UserException)
	def void diegoYaSaleConRocio() {
		val saleConRocio = new Relacion => [
			persona = rocio
			esFiel = true
		]

		diego.addRelacion(saleConRocio)
		diego.addRelacion(saleConRocio)
	}
	
	@Test(expected=UserException)
	def void diegoNoPuedeSalirConsigoMismo() {
		val saleConDiego = new Relacion => [
			persona = diego
			esFiel = true
		]

		diego.addRelacion(saleConDiego)
	}

	@Test(expected=UserException)
	def void diegoNoEsBotinera() {
		diego.removeOficio(botinera)
	}

	@Test(expected=UserException)
	def void veronicaNoSaleConRocio() {
		val saleConRocio = new Relacion => [
			persona = rocio
			esFiel = true
		]

		veronica.removeRelacion(saleConRocio)
	}

}
