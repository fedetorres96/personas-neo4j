package arena

import domain.Oficio
import domain.Persona
import domain.Relacion
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.CheckBox
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.NumericField
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.Selector
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.widgets.tables.Table
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

import static extension arena.utils.TableColumnBuilder.*
import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class PersonasWindow extends SimpleWindow<PersonasModel> {

	new(WindowOwner parent, PersonasModel model) {
		super(parent, model)
	}

	override createFormPanel(Panel panel) {
		title = "Personas y Oficios"

		var panelPersonas = new Panel(panel)

		createPersonasPanel(panelPersonas)

		var panelInfo = new Panel(panel).layout = new HorizontalLayout
		var panelOficios = new Panel(panelInfo)
		var panelRelaciones = new Panel(panelInfo)

		createOficiosPanel(panelOficios)
		createRelacionesPanel(panelRelaciones)
	}

	def void createPersonasPanel(Panel panel) {
		new Label(panel).text = "Personas"

		val panelPersona = new Panel(panel).layout = new HorizontalLayout

		new Label(panelPersona).text = "Nombre y Apellido"
		new TextBox(panelPersona) => [
			value <=> "nombre"
			width = 150
		]

		new Label(panelPersona).text = "Fecha Nacimiento"
		new TextBox(panelPersona) => [
			value <=> "fecha"
			width = 150
		]

		val panelBotonera = new Panel(panel).layout = new HorizontalLayout

		new Button(panelBotonera) => [
			caption = "Actualizar persona"
			onClick([modelObject.actualizarPersona])
		]

		new Button(panelBotonera) => [
			caption = "Buscar persona"
			onClick([modelObject.buscarPersona])
		]

		new Button(panelBotonera) => [
			caption = "Reiniciar"
			onClick([modelObject.cargarPersonas])
		]

		var table = new Table<Persona>(panel, Persona) => [
			numberVisibleRows = 5
			items <=> "personas"
			value <=> "personaSeleccionada"
		]

		table.buildColumn("Nombre y apellido", 310, "nombre")
		table.buildColumn("Fecha Nacimiento", 310, "fechaNacimiento")

	}

	def void createOficiosPanel(Panel panel) {
		new Label(panel).text = "Oficios"

		val panelOficios = new Panel(panel).layout = new HorizontalLayout

		new Label(panelOficios).text = "Oficio"
		new Selector(panelOficios) => [
			items <=> "oficios"
			value <=> "nuevoOficio"
			width = 150
		]

		new Label(panelOficios).text = "Destreza"
		new NumericField(panelOficios) => [
			value <=> "nuevoOficio.gradoDestreza"
			width = 50
		]

		new Button(panel) => [
			caption = "Agregar oficio"
			onClick([modelObject.agregarOficio])
		]

		var table = new Table<Oficio>(panel, Oficio) => [
			numberVisibleRows = 5
			items <=> "personaSeleccionada.oficios"
			value <=> "oficioSeleccionado"
		]

		table.buildColumn("Nombre", 200, "nombre")

		table.buildColumn("Grado de destreza", 20, "gradoDestreza")

		new Button(panel) => [
			caption = "Eliminar oficio"
			onClick([modelObject.eliminarOficio])
		]
	}

	def void createRelacionesPanel(Panel panel) {
		new Label(panel).text = "Sale con"

		val panelRelaciones = new Panel(panel).layout = new HorizontalLayout

		new Label(panelRelaciones).text = "Persona"
		new Selector(panelRelaciones) => [
			items <=> "relaciones"
			value <=> "nuevaRelacion.persona"
			width = 150
		]

		new Label(panelRelaciones).text = "Es fiel"
		new CheckBox(panelRelaciones) => [
			value <=> "nuevaRelacion.esFiel"
			width = 50
		]

		new Button(panel) => [
			caption = "Agregar relación"
			onClick([modelObject.agregarRelacion])
		]

		var table = new Table<Relacion>(panel, Relacion) => [
			numberVisibleRows = 5
			items <=> "personaSeleccionada.relaciones"
			value <=> "relacionSeleccionada"
		]

		table.buildColumn("Persona", 200, "persona")

		table.buildColumn("Fiel", 100).bindContentsToProperty("esFiel").transformer = [ boolean esFiel |
			if(esFiel) "Si" else "No"
		]

		new Button(panel) => [
			caption = "Eliminar relación"
			onClick([modelObject.eliminarRelacion])
		]
	}

	override addActions(Panel panel) {

		new Button(panel) => [
			caption = "Salir"
			onClick( [close])
		]

	}

}
