//
//  DetalleDeLibroViewController.swift
//  BuscadorDeLibros
//
//  Created by Gerardo Guerra Pulido on 31/01/16.
//  Copyright © 2016 Gerardo Guerra Pulido. All rights reserved.
//

import UIKit

class DetalleDeLibroViewController: UIViewController {
    
    var isbn: String = ""
    var titulo: String = ""
    var autores: String? = nil
    var urlPortada: String? = nil
    
    @IBOutlet weak var lblISBN: UILabel!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var labelAutores: UILabel!
    @IBOutlet weak var lblAutores: UILabel!
    @IBOutlet weak var imgPortada: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        lblISBN.text = self.isbn
        lblTitulo.text = self.titulo
        if self.autores != nil {
            lblAutores.text = self.autores
        } else {
            lblAutores.text = ""
        }
        if self.urlPortada != nil {
            if let url = NSURL(string: self.urlPortada!) {
                if let data = NSData(contentsOfURL: url) {
                    imgPortada.image = UIImage(data: data)
                    imgPortada.sizeToFit()
                }
            }
        } else {
            imgPortada.image = nil
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
