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
        var titulo: String = ""
        var autores: String? = nil
        var portada: String? = nil
        
        init(titulo:String, autores:String?, portada:String?){
            self.titulo = titulo
            self.autores = autores
            self.portada = portada
        }
    }
}

