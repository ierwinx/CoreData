import UIKit
import CoreData

class MarcaRepository {
    
    public func guardarCoreData(id: Int, palabra: String) -> NSManagedObject? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entidadMarcas = NSEntityDescription.entity(forEntityName: "Marcas", in: managedContext) else {
            return nil
        }
        let managedObject = NSManagedObject(entity: entidadMarcas, insertInto: managedContext)
        managedObject.setValue(Int32(id + 1), forKey: "id")
        managedObject.setValue(palabra, forKey: "nombre")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error al guardar informacion: \(error)")
        }
        return managedObject // lo retorno para poder mostrarlo en la lista pero no es necesario
    }
    
    public func leerCoreData() -> Array<NSManagedObject> {
        var respuesta: Array<NSManagedObject> = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return respuesta }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequestResult = NSFetchRequest<NSManagedObject>(entityName: "Marcas")
        
        do {
            respuesta = try managedContext.fetch(fetchRequestResult)
        } catch let error as NSError {
            print("Error al leer informacion: \(error)")
        }
        
        return respuesta
    }
    
    public func borrarCoreData(id: Int) -> Void {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Marcas")
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        do {
            let busca = try managedContext.fetch(fetchRequest)
            
            let elimina = busca[0] as! NSManagedObject
            managedContext.delete(elimina)
        } catch let error as NSError {
            print("Error al eliminar informacion: \(error)")
        }
    }
    
    public func editarCoreData(id: Int, palabra: String) -> Void {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Marcas")
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        do {
            let busca = try managedContext.fetch(fetchRequest)
            
            let actualizar = busca[0] as! NSManagedObject
            actualizar.setValue (palabra, forKey: "nombre")
            try managedContext.save()
        } catch let error as NSError {
            print("Error al eliminar informacion: \(error)")
        }
    }
    
}
