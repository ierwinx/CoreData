import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tabla: UITableView!
    
    public var managedObjectContext: NSManagedObjectContext!
    
    private var entidad = "Persona"
    private var entidad2 = "Caminadas"
    lazy var fotmatoFecha: DateFormatter = {
        let formato = DateFormatter()
        formato.dateStyle = .short
        formato.timeStyle = .medium
        return formato
    }()
    
    var personaActual: Persona!

    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        crearDatosCoreData()
    }
    
    func crearDatosCoreData() -> Void {
        let peticion = NSFetchRequest<Persona>(entityName: entidad)
        peticion.predicate = NSPredicate(format: "id != nil")
        
        let cantidad = try! managedObjectContext.count(for: peticion)
        
        // si no existen los datos en CoreData se almacenan
        if cantidad == 0 {
            guard let entity = NSEntityDescription.entity(forEntityName: entidad, in: managedObjectContext) else { return }
            guard let entity2 = NSEntityDescription.entity(forEntityName: entidad2, in: managedObjectContext) else { return }
            let persona = Persona(entity: entity, insertInto: managedObjectContext)
            persona.id = UUID()
            persona.nombre = "Erwin"
            
            let caminadas = Caminadas(entity: entity2, insertInto: managedObjectContext)
            caminadas.id = UUID()
            caminadas.fecha = Date()
            caminadas.persona = persona
            
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print(error)
            }
            print("Se almaceno todo correctamente")
            
        } else {
            let peticion = NSFetchRequest<Persona>(entityName: entidad)
            peticion.predicate = NSPredicate(format: "nombre != nil")
            do {
                let resultado = try managedObjectContext.fetch(peticion)
                guard let encontrado = resultado.first else {
                    return
                }
                personaActual = encontrado
                
            } catch let error as NSError {
                print(error)
            }
        }
    }
    


    @IBAction func addAction(_ sender: Any) {
        
        guard let persona = personaActual else {
            return
        }
        
        let nuevaCominata = Caminadas(context: managedObjectContext)
        nuevaCominata.id = UUID()
        nuevaCominata.fecha = Date()
        
        guard let caminatas = persona.caminatas?.mutableCopy() as? NSMutableOrderedSet else {
            return
        }
        caminatas.add(nuevaCominata)
        persona.caminatas = caminatas
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print(error)
        }
        print("Se almaceno todo correctamente")
        
        personaActual = persona
        tabla.reloadData()
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.personaActual.caminatas?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdaX", for: indexPath)
        guard let caminatasEncontradas = self.personaActual.caminatas?[indexPath.row] as? Caminadas else {
            return celda
        }
        celda.textLabel?.text = self.fotmatoFecha.string(from: caminatasEncontradas.fecha!)
        return celda
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let caminatasEncontradas = self.personaActual.caminatas?[indexPath.row] as? Caminadas,
            editingStyle == .delete else {
            return
        }
        
        self.managedObjectContext.delete(caminatasEncontradas)
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print(error)
        }
        print("Se elimino correctamente")
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}
