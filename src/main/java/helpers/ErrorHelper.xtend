package helpers

import org.uqbar.commons.model.UserException

class ErrorHelper {
	def static void capturarError(String mensaje, ()=>void funcion){
		try{
			funcion.apply();
		}catch(Exception e){
			throw new Exception(mensaje)
		}
	}
	
	def static void capturarUserError(()=>void funcion){
		try{
			funcion.apply();
		}catch(Exception e){
			throw new UserException(e.message)
		}
	}
}