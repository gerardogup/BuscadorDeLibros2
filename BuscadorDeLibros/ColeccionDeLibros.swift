//
//  ColeccionDeLibros.swift
//  BuscadorDeLibros
//
//  Created by Gerardo Guerra Pulido on 31/01/16.
//  Copyright © 2016 Gerardo Guerra Pulido. All rights reserved.
//

import Foundation

public class ColeccionDeLibros {
    static var Libros: [Libro] = []
    
    public struct Libro {
        var isbn: String = ""
        var titulo: String = ""
        var autores: String? = nil
        var portada: String? = nil
        
        init(isbn:String, titulo:String, autores:String?, portada:String?){
            self.isbn = isbn
            self.titulo = titulo
            self.autores = autores
            self.portada = portada
        }
    }
}

