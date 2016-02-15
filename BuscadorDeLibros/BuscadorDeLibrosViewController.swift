//
//  BuscadorDeLibrosViewController.swift
//  BuscadorDeLibros
//
//  Created by Gerardo Guerra Pulido on 31/01/16.
//  Copyright © 2016 Gerardo Guerra Pulido. All rights reserved.
//

import UIKit
import CoreData

class BuscadorDeLibrosViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtISBN: UITextField!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblAutor: UILabel!
    @IBOutlet weak var imgPortada: UIImageView!
    @IBOutlet weak var labelAutores: UILabel!
    
    var urlPortada: String? = nil
    var contexto: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        // Do any additional setup after loading the view.
        txtISBN.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buscarLibro(sender: UITextField) {
        sender.resignFirstResponder()
        
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + sender.text!
        let url = NSURL(string: urls)
        
        let datos = NSData(contentsOfURL: url!)
        if datos != nil {
            do {
                //let json = NSString(data:datos!, encoding: NSUTF8StringEncoding)
                //self.tvDescripcion.text = String(json)
                let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                let dico1 = json as! NSDictionary
                let dico2 = dico1["ISBN:" + sender.text!] as! NSDictionary
                self.lblTitulo.text = dico2["title"] as! NSString as String
                let autores = dico2["authors"] as? [[String : String]]
                if autores != nil {
                    self.lblAutor.text = ""
                    for autor in autores! {
                        let nombreDelAutor = autor["name"]
                        self.lblAutor.text?.appendContentsOf(nombreDelAutor!)
                        if autores!.count > 1 {
                            self.lblAutor.text?.appendContentsOf(" & ")
                        }
                    }
                }
                if autores?.count > 1 {
                    labelAutores.text = "Autores"
                } else if autores == nil {
                    labelAutores.text = "Autor"
                    lblAutor.text = "No Disponible"
                } else {
                    labelAutores.text = "Autor"
                }
                if dico2["cover"] != nil {
                    let dico3 = dico2["cover"] as! NSDictionary
                    urlPortada = dico3["medium"] as! NSString as String
                    if let url = NSURL(string: dico3["medium"] as! NSString as String) {
                        if let data = NSData(contentsOfURL: url) {
                            imgPortada.image = UIImage(data: data)
                            imgPortada.sizeToFit()
                        }
                    }
                } else {
                    urlPortada = nil
                }
                
            } catch _ {
                alertaDeError("Ha ocurrido un error con el origen de datos.")
            }
            
        } else {
            alertaDeError("Ha habido un error al tratar de obtener la información relacionada al ISBN. Verifica tu conexión a internet.")
        }

    }
    
    @IBAction func limpiarResultados(sender: UITextField) {
        if self.txtISBN.text == "" {
            lblTitulo.text = ""
            lblAutor.text = ""
            imgPortada.image = nil
        }
    }
    
    func obtenerAutores (autores: String) -> Set<NSObject> {
        var autoresEntidades = Set<NSObject>()
        if(autores != ""){
            let autoresArr = autores.characters.split{$0 == "&"}.map(String.init)
            for autorStr in autoresArr {
                let autorEntidad = NSEntityDescription.insertNewObjectForEntityForName("Autor", inManagedObjectContext: self.contexto!)
                autorEntidad.setValue(autorStr, forKey: "nombre")
                autoresEntidades.insert(autorEntidad)
            }
        }
        return autoresEntidades
    }
    
    @IBAction func guardarLibro(sender: UIBarButtonItem) {
        //agregar libro a la colección
        if lblTitulo.text != nil && lblTitulo.text != "" {
            //ColeccionDeLibros.Libros.append(ColeccionDeLibros.Libro(isbn: txtISBN.text!, titulo: lblTitulo.text!, autores: lblAutor.text, portada: urlPortada))
            let nuevoLibro = NSEntityDescription.insertNewObjectForEntityForName("Libro", inManagedObjectContext: self.contexto!)
            nuevoLibro.setValue(txtISBN.text!, forKey: "isbn")
            nuevoLibro.setValue(lblTitulo.text!, forKey: "titulo")
            if imgPortada.image != nil {
                nuevoLibro.setValue(UIImagePNGRepresentation(imgPortada.image!), forKey: "portada")
            }
            nuevoLibro.setValue(obtenerAutores(lblAutor.text!), forKey: "tiene")
            do {
                try self.contexto?.save()
            }
            catch {
                
            }
            
            //cerrar el modal
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func cancelarBusqueda(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func backgroundTap(sender: UIControl) {
        txtISBN.resignFirstResponder()
    }
    
    func alertaDeError(mensaje: String){
        let alerta = UIAlertController(title: "Error", message: mensaje, preferredStyle: UIAlertControllerStyle.Alert)
        alerta.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            alerta.dismissViewControllerAnimated(true, completion: nil)
        }))
        presentViewController(alerta, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
