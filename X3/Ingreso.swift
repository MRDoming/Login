//
//  File.swift
//  X3
//
//  Created by Maria Dominguez on 23/09/2021.
//

import Foundation
import UIKit


struct Ingreso: Encodable {
    let email: String?
    let pwd: String?
}


struct Respuesta: Decodable {
    let name:  String
    let img_profile: String
}


struct UsuarioNuevo: Encodable {
    let name: String
    let email: String
    let pwd: String
    let img: String
}

struct RespuestaImagen: Decodable {
    let path: String
}

