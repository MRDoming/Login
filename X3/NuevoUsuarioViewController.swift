//
//  NuevoUsuarioViewController.swift
//  X3
//
//  Created by Maria Dominguez on 04/10/2021.
//

//CAMBIO PULL REQUEST


import UIKit
import CryptoKit
import Alamofire


class NuevoUsuarioViewController: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var nombreNuevo: UITextField!
    @IBOutlet weak var emailNuevo: UITextField!
    @IBOutlet weak var contraseniaNueva: UITextField!
    @IBOutlet weak var imagenNueva: UITextField!
    
    @IBOutlet weak var camposObligatorios: UILabel!
    
    @IBOutlet weak var imagenPerfil: UIImageView!
    var imgStringFinal: String = ""
    //var emailIngresado = ""
    //var contraseniaIngresada = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.navigationItem.setHidesBackButton(false, animated: true)
        contraseniaNueva.isSecureTextEntry = true
        //imagenPerfil.image = UIImage (named:"Ipa.jpg")
        imagePicker.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func guardarUsuarioAction(_ sender: Any) {
        
       upload (completion: { (imgString)  in
            //imagenPerfil.image = UIImage (named:"\(imgString)")
           self.imgStringFinal = imgString
           self.guardarPosta()
        })
                
    }
    func guardarPosta() {
        
        let contraseniaAsh: String = contraseniaNueva.text ?? ""
        let textInputData2 = Data(contraseniaAsh.utf8)
        let textHashed2 = SHA256.hash(data: textInputData2)
        let pass:String = textHashed2.compactMap { String(format: "%02x", $0) }.joined()
        if nombreNuevo.text == "" || emailNuevo.text == "" || contraseniaNueva.text == "" ||  imgStringFinal == ""
              {
            camposObligatorios.textColor = .black
            camposObligatorios.backgroundColor = .red
        } else {
            let usuarioNuevo = UsuarioNuevo(name: nombreNuevo.text ?? "", email: emailNuevo.text ?? "", pwd: pass, img: imgStringFinal)

            
            alamofire.shared.nuevoUsuario(user: usuarioNuevo) {
                print(usuarioNuevo)
                
                
                self.performSegue(withIdentifier: "Volver", sender: self)
                
            }
        }
    }
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HolaViewController {
            let vc = segue.destination as? HolaViewController
                    vc?.emailStr = emailIngresado
            vc?.contraseniaStr = contraseniaIngresada
        }
    }*/
    
    @IBAction func subirImagen(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagenPerfil?.image = img
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)

    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func upload (completion: @escaping (_ user: String) -> Void){
    let headers: HTTPHeaders = [.contentType("application/json")]
        
    AF.upload(multipartFormData: { multipartFormData in multipartFormData.append((self.imagenPerfil.image?.jpegData(compressionQuality: 0.5))!, withName: "files" , fileName: "file.jpeg", mimeType: "image")
                },
              to: "http://192.168.2.3:8080/upload", method: .post , headers: headers).responseDecodable (of: RespuestaImagen.self) { response in
                         /*let data = response.data
                            let json = String(data: data!, encoding: String.Encoding.utf8)*/
                        let imgString = response.value?.path
                        completion(imgString!)
                        print(response.response?.statusCode)
                }
    }

}
