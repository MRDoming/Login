//
//  ViewController.swift
//  X3
//
//  Created by Maria Dominguez on 16/09/2021.
//

import UIKit

import CryptoKit

import Alamofire
import SystemConfiguration


class ViewController: UIViewController {
    
    @IBOutlet weak var informe: UILabel!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var contraseña: UITextField!
    
    let emailCorrecto: String = "hola"
    //let contraseñaCorrecta: String = "canasta"

    var laImagen: String = ""
    var elNombre: String = ""
    var emailIngresado = ""
    var contraseniaIngresada = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true);
        
        email?.keyboardType = .emailAddress
        contraseña?.keyboardType = .emailAddress
        informe?.isHidden = true
        contraseña?.isSecureTextEntry = true
        
        
        
    
        // Do any additional setup after loading the view.
    }
    @IBAction func ingresarAction(_ sender: Any) {
        self.hideKeyboard()
        
        let contraseña3: String = contraseña.text!
        let textInputData = Data(contraseña3.utf8)
        let textHashed = SHA256.hash(data: textInputData)
        let x:String = textHashed.compactMap { String(format: "%02x", $0) }.joined()
        
        contraseniaIngresada = x
        emailIngresado = email.text ?? ""
        
        let usuarioIngresado = Ingreso(email: email.text, pwd: x)
        

        if email.text == "" || contraseña.text == "" {
            self.informe.isHidden = false
        } else {
            alamofire.shared.imag(user: usuarioIngresado) { [self] imagen2, nombre  in
            self.laImagen = imagen2
            self.elNombre = nombre
            self.performSegue(withIdentifier: "Aprobado", sender: self)
            } failure: {
            self.informe.isHidden = false
            }
        }
    }
   
    
    @IBAction func crearUsuarioAction(_ sender: Any) {
        //performSegue(withIdentifier: "NuevoUsuario", sender: self)
    }
    
    
    func comparar() -> (Bool) {
       //Convertir el textField en String
        let email3: String = email.text ?? ""
        let contraseña3: String = contraseña.text ?? ""
        
        let textInputData = Data(contraseña3.utf8)
        let textHashed = SHA256.hash(data: textInputData)
        
       
        //Guardar los resultados en una constante
        let x:String = textHashed.compactMap { String(format: "%02x", $0) }.joined()
        let x2:String = "3f7aada6d094084dda6510289cfe1cda903728c3725da7c373bc9551b12a6dcd"
        
        //Comparar las constantes
        if(email3.caseInsensitiveCompare(emailCorrecto) == .orderedSame) && (x.caseInsensitiveCompare(x2) == .orderedSame){
            informe.isHidden = true
            //performSegue(withIdentifier: "Aprobado", sender: self.self)
                print("voila")
            return true
        } else {
            informe.isHidden = false
            print("Error")
            return false
            }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HolaViewController {
            let vc = segue.destination as? HolaViewController
                    vc?.imagenStr = laImagen
                    vc?.nombreStr = elNombre
                    vc?.emailStr = emailIngresado
                    vc?.contraseniaStr = contraseniaIngresada
        }
    }
}

extension ViewController {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

