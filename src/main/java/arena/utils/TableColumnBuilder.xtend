package arena.utils

import org.uqbar.arena.widgets.tables.Column
import org.uqbar.arena.widgets.tables.Table

class TableColumnBuilder {

	def static Column<?> buildColumn(Table<?> _table, String _title, int _fixedSize) {
		var column = new Column(_table) => [
			title = _title
			fixedSize = _fixedSize
		]

		column
	}

	def static Column<?> buildColumn(Table<?> _table, String _title, int _fixedSize, String _bindedField) {
		var column = new Column(_table) => [
			title = _title
			fixedSize = _fixedSize
			bindContentsToProperty(_bindedField)
		]

		column
	}

}
