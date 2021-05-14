import Foundation
import CoreData

extension Automivil {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Automivil> {
        return NSFetchRequest<Automivil>(entityName: "Automivil")
    }

    @NSManaged public var vecesProbado: Int16
    @NSManaged public var ultimaPrueba: Date?
    @NSManaged public var nombreImagen: String?
    @NSManaged public var calificacion: Double
    @NSManaged public var busqueda: String?
    @NSManaged public var nombre: String?
    @NSManaged public var datosImagen: Data?

}
