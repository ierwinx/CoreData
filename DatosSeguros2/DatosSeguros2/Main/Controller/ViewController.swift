import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var tipos: UISegmentedControl!
    
    @IBOutlet weak var modeloLabel: UILabel!
    @IBOutlet weak var calificacionLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    
    public var managedObjectContext: NSManagedObjectContext! // se llena en el SceneDelegate
    private var entidad: String = "Automivil"
    private var autoSeleccionado: String!
    private var autoEncontrado: Automivil!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guardarDatosPlist()
        
        autoSeleccionado = tipos.titleForSegment(at: 0)!
        mostrarDatos(titulo: autoSeleccionado)
    }
    
    private func mostrarDatos(titulo: String) -> Void {
        let peticion = NSFetchRequest<Automivil>(entityName: entidad)
        
        peticion.predicate = NSPredicate(format: "busqueda == %@", titulo)
        
        do {
            let resultados = try managedObjectContext.fetch(peticion)
            resultados.forEach { i in
                autoEncontrado = i
                imagen.image = UIImage(data: i.datosImagen!)
                modeloLabel.text = "Modelo: \(i.nombre!)"
                calificacionLabel.text = "Calificación: \(i.calificacion)"
                totalLabel.text = "Veces probado: \(i.vecesProbado)"
                
                let formato = DateFormatter()
                formato.dateStyle = .medium
                fechaLabel.text = "Ultima prueba: \(formato.string(from: i.ultimaPrueba!))"
            }
            
        } catch let error as NSError {
            print("Error al guardar informacion: \(error)")
        }
        
    }
    
    private func guardarDatosPlist() -> Void {
        let peticion = NSFetchRequest<Automivil>(entityName: entidad)
        peticion.predicate = NSPredicate(format: "nombre != nil")
        
        let cantidad = try! managedObjectContext.count(for: peticion)
        
        // si no existen los datos en CoreData se almacenan
        if cantidad == 0 {
            guard let datosPlist = Bundle.main.path(forResource: "DatosIniciales", ofType: "plist"), let arregloDatosPlist = NSArray(contentsOfFile: datosPlist) else {
                return
            }
            
            arregloDatosPlist.forEach { i in
                let diccionarioAuto = i as! [String: AnyObject]
                
                guard let entity = NSEntityDescription.entity(forEntityName: entidad, in: managedObjectContext) else { return }
                
                let automovil = Automivil(entity: entity, insertInto: managedObjectContext)
                automovil.nombre = diccionarioAuto["nombre"] as? String
                automovil.busqueda = diccionarioAuto["busqueda"] as? String
                automovil.calificacion = diccionarioAuto["calificacion"] as! Double
                        
                guard let nombreArchivo = diccionarioAuto["nombreImagen"] as? String, let imagen = UIImage(named: nombreArchivo) else { return }
                let imagenData: Data = imagen.jpegData(compressionQuality: 0.5)!
                
                automovil.datosImagen = imagenData
                automovil.ultimaPrueba = diccionarioAuto["ultimaPrueba"] as? Date
                
                let vecesProbado = diccionarioAuto["vecesProbado"] as! NSNumber
                automovil.vecesProbado = vecesProbado.int16Value
                
                do {
                    try managedObjectContext.save()
                } catch let error as NSError {
                    print("Error al guardar informacion: \(error)")
                }

            }
            
            print("Información guardada exitosamente")
            
        }
    }

    @IBAction func tiposAction(_ sender: Any) {
        guard let selector = sender as? UISegmentedControl else {
            return
        }
        autoSeleccionado = selector.titleForSegment(at: selector.selectedSegmentIndex)
        mostrarDatos(titulo: autoSeleccionado!)
    }
    
    @IBAction func probarAction(_ sender: Any) {
        do {
            let vecesProbado = autoEncontrado.vecesProbado
            autoEncontrado.vecesProbado = vecesProbado + 1
            autoEncontrado.ultimaPrueba = Date()
            
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Error al guardar informacion: \(error)")
        }
        
        mostrarDatos(titulo: autoSeleccionado)
    }
    
    @IBAction func calificarAction(_ sender: Any) {
        let alerta = UIAlertController(title: "Calificación", message: "Califica el Automovil", preferredStyle: .alert)
        alerta.addTextField { campoTexto in
            campoTexto.keyboardType = .decimalPad
        }
        
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel)
        
        let guardar = UIAlertAction(title: "Guardar", style: .default) { accion in
            guard let  campoTexto = alerta.textFields?.first else {
                return
            }
            
            guard let stringCalificación = campoTexto.text, let calificacion = Double(stringCalificación) else { return }
            
            self.autoEncontrado.calificacion = calificacion
            
            do {
                try self.managedObjectContext.save()
            } catch let error as NSError {
                print("Error al guardar informacion: \(error)")
            }
            
            self.mostrarDatos(titulo: self.autoSeleccionado)
        }
        
        alerta.addAction(cancelar)
        alerta.addAction(guardar)
        present(alerta, animated: true)
    }
    
}

