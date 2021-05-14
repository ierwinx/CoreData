import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // le paso el NSManagedObjectContext a la clase ViewController // solo swift 5, en swift 4 pasar codigo al AppDelegate
        guard let view = window?.rootViewController as? ViewController else {
            return
        }
        view.managedObjectContext = AppDelegate().persistentContainer.viewContext
        
        /*
        Ejemplo
        guard let automivilFiesta = NSEntityDescription.insertNewObject(forEntityName: "Automivil", into: self.persistentContainer.viewContext) as? Automivil else {
            return false
        }
        automivilFiesta.nombre = "Ford Fiesta"
        automivilFiesta.ultimaPrueba = Date()
        
        do {
            let peticion = NSFetchRequest<Automivil>(entityName: "Automivil")
            let automoviles = try self.persistentContainer.viewContext.fetch(peticion)
            print(automoviles)
            print(automoviles.first!)
            print(automoviles.first!.nombre!)
        } catch let error as NSError {
            print("Error al guardar informacion: \(error)")
        }*/
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

}

