//
//  ColeccionDeLibros.swift
//  BuscadorDeLibros
//
//  Created by Gerardo Guerra Pulido on 31/01/16.
//  Copyright © 2016 Gerardo Guerra Pulido. All rights reserved.
//

import Foundation
import UIKit

public class ColeccionDeLibros {
    static var Libros: [Libro] = []
    
    public struct Autor {
        var nombre: String = ""
        
        init(nombre: String){
            self.nombre = nombre
        }
    }
    
    public struct Libro {
        var isbn: String = ""
        var titulo: String = ""
        var autores: [Autor] = []
        var portadaImg: UIImage? = nil
        
        init(isbn:String, titulo:String, autores:[Autor], portadaImg:UIImage?){
            self.isbn = isbn
            self.titulo = titulo
            self.autores = autores
            self.portadaImg = portadaImg
        }
    }
}

