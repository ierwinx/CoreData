import UIKit
import CoreData

class ListaTableViewController: UITableViewController {
    
    var marcas: Array<NSManagedObject> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let marcasRepository = MarcaRepository()
        marcas = marcasRepository.leerCoreData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return marcas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "celdaX", for: indexPath)
        cell.textLabel?.text = marcas[indexPath.row].value(forKey: "nombre") as? String
        return cell
    }
    
    @IBAction func agregarAction(_ sender: Any) {
        creaAlerta(guardar: true, id: nil)
    }
    
    private func creaAlerta(guardar: Bool, id: Int?) -> Void {
        let alerta = UIAlertController(title: "Agregando nueva palabra", message: nil, preferredStyle: .alert)
        
        let guardarButton = UIAlertAction(title: "Agregar", style: .default) { accion in
            let textField1 = alerta.textFields?.first
            guard let marca = textField1?.text else { return }
            let marcasRepository = MarcaRepository()
            if guardar {
                guard let datoGuardar = marcasRepository.guardarCoreData(id: self.marcas.count, palabra: marca) else {
                    return
                }
                self.marcas.append(datoGuardar)
            } else {
                marcasRepository.editarCoreData(id: id!, palabra: marca)
                self.marcas = marcasRepository.leerCoreData()
            }
            self.tableView.reloadData()
        }
        
        alerta.view.tintColor = UIColor.blue
        alerta.addTextField { textField in
            textField.placeholder = "Escribe una marca de carro"
        }
        alerta.addAction(guardarButton)
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        
        present(alerta, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let marcasRepository = MarcaRepository()
        
        let borrarAction = UITableViewRowAction(style: .destructive, title: "Borrar") { (_, _) in
            guard let idSeleccionado = self.marcas[indexPath.row].value(forKey: "id") as? Int else {
                return
            }
            marcasRepository.borrarCoreData(id: idSeleccionado)
            self.marcas = marcasRepository.leerCoreData()
            tableView.reloadData()
        }
        let editarAction = UITableViewRowAction(style: .normal, title: "Editar") { (_, _) in
            guard let idSeleccionado = self.marcas[indexPath.row].value(forKey: "id") as? Int else {
                return
            }
            self.creaAlerta(guardar: false, id: idSeleccionado)
        }
        return [borrarAction, editarAction]
    }
    
}
