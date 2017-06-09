package helpers

import org.uqbar.commons.model.UserException

class ErrorHelper {

	def static void capturarError(()=>void funcion, String mensaje ) {
		try {
			funcion.apply();
		} catch (Exception e) {
			throw new UserException(mensaje)
		}
	}

	def static void mostrarError(boolean condicion, String error) {
		if (condicion) {
			throw new UserException(error)
		}
	}

}
