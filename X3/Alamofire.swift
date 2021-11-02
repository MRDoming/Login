//
//  Alamofire.swift
//  X3
//
//  Created by Maria Dominguez on 28/09/2021.
//

import Foundation

import Alamofire
import SwiftUI

final class alamofire {
 var elefante = ""
   static let shared = alamofire()
    let kUrl = "http://192.168.2.3:8080/v1/user"
    let kStatusOk = 200...299
    let headers: HTTPHeaders = [.contentType("application/json")]
    
    func imag(user: Ingreso, success: @escaping (_ user: String, _ user: String) -> (), failure: @escaping () -> ()){
        
        AF.request(kUrl, method: .post, parameters: user, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: kStatusOk).responseDecodable (of: Respuesta.self) {
            response in
            let user2 = response.value?.img_profile
            let nombre = response.value?.name
            if (response.response?.statusCode) == 200  && response.value?.name != nil {
                success(user2!,nombre!)
            } else {
                failure()
            }
        }
}
    

func post (user: Ingreso, success: @escaping () -> (), failure: @escaping () -> ()) {
    
    
    AF.request(kUrl, method: .post, parameters: user, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: kStatusOk).response {
        response in
        if (response.response?.statusCode) == 200 {
            success()
        } else {
            failure()
        }
    }
}
    
    func nuevoUsuario (user: UsuarioNuevo, success: @escaping () -> ()) {
    
        AF.request(kUrl, method: .put, parameters: user, encoder: JSONParameterEncoder.default, headers: headers).validate(statusCode: kStatusOk).responseDecodable (of: Respuesta.self) {
            response in
                success()
        }
    }
}


