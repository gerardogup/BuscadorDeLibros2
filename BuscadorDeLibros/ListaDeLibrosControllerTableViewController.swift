//
//  ListaDeLibrosControllerTableViewController.swift
//  BuscadorDeLibros
//
//  Created by Gerardo Guerra Pulido on 31/01/16.
//  Copyright © 2016 Gerardo Guerra Pulido. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class ListaDeLibrosControllerTableViewController: UITableViewController {

    //var Libros = ColeccionDeLibros.Libros
    var Libros: [ColeccionDeLibros.Libro] = []
    var contexto: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        cargarLibros()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    func cargarLibros() {
        self.Libros = []
        let libroEntidad = NSEntityDescription.entityForName("Libro", inManagedObjectContext: self.contexto!)
        let peticion = libroEntidad?.managedObjectModel.fetchRequestTemplateForName("petLibros")
        do {
            let librosEntidad = try self.contexto?.executeFetchRequest(peticion!)
            for libro in librosEntidad! {
                let isbn = libro.valueForKey("isbn") as! String
                let titulo = libro.valueForKey("titulo") as! String
                let autores = libro.valueForKey("tiene") as! Set<NSObject>
                var autores2: [ColeccionDeLibros.Autor] = []
                for autor in autores {
                    let nombre: String = autor.valueForKey("nombre") as! String
                    autores2.append(ColeccionDeLibros.Autor(nombre: nombre))
                }
                var portadaImg: UIImage? = nil
                if libro.valueForKey("portada") != nil {
                    portadaImg = UIImage(data: libro.valueForKey("portada") as! NSData)
                }
                
                self.Libros.append(ColeccionDeLibros.Libro(isbn: isbn, titulo: titulo, autores: autores2, portadaImg: portadaImg))
            }
        } catch {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        //Libros = ColeccionDeLibros.Libros
        
        cargarLibros()
        
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Libros.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel!.text = Libros[indexPath.item].titulo

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //ColeccionDeLibros.Libros.removeAtIndex(indexPath.item)
            //Libros = ColeccionDeLibros.Libros
            let libroEntidad = NSEntityDescription.entityForName("Libro", inManagedObjectContext: self.contexto!)
            let peticion = libroEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petLibro", substitutionVariables: ["isbn" : Libros[indexPath.item].isbn])
            do {
                let libroAEliminar = try self.contexto?.executeFetchRequest(peticion!)
                if libroAEliminar?.count > 0 {
                    self.contexto?.deleteObject(libroAEliminar![0] as! NSManagedObject)
                }
                try self.contexto?.save()
            }
            catch {
                
            }
            
            Libros.removeAtIndex(indexPath.item)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mostrarDetalle" {
            // Get the new view controller using segue.destinationViewController.
            let detalle = segue.destinationViewController as! DetalleDeLibroViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            detalle.isbn = Libros[indexPath!.item].isbn
            detalle.titulo = Libros[indexPath!.item].titulo
            for autor in Libros[indexPath!.item].autores {
                detalle.autores = autor.nombre
                if Libros[indexPath!.item].autores.count > 1 {
                    detalle.autores += " & "
                }
            }
            detalle.portadaImg = Libros[indexPath!.item].portadaImg
            // Pass the selected object to the new view controller.

        }
   }
    

}
