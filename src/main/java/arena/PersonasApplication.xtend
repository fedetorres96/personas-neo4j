package arena

import org.uqbar.arena.Application
import org.uqbar.commons.utils.ApplicationContext
import repos.RepoOficios
import repos.RepoPersonas

class PersonasApplication extends Application {

	def static void main(String[] args) {
		ApplicationContext.instance.configureSingleton(RepoPersonas, new RepoPersonas)
		ApplicationContext.instance.configureSingleton(RepoOficios, new RepoOficios)

		new PersonasApplication().start
	}

	override protected createMainWindow() {
		new PersonasWindow(this, new PersonasModel)
	}

}
