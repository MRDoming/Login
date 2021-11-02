//
//  HolaViewController.swift
//  X3
//
//  Created by Maria Dominguez on 17/09/2021.
//

import UIKit
import Kingfisher
//import MobileCoreServices
import Alamofire


class HolaViewController: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var hola: UILabel!
    
    @IBOutlet weak var imagen: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    var imagenStr: String = ""
    var nombreStr: String = ""
    var imgStringFinal: String = ""
    var emailStr: String = ""
    var contraseniaStr: String = ""
    var imagenUpload = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagen.layer.cornerRadius = (self.imagen?.frame.size.width)! / 2.4
        imagen.clipsToBounds = true
        imagePicker.delegate = self

        hola.text = "Hola \(nombreStr)"
        if imagenStr == "" {
            imagen.image = UIImage (named: "Ipa")
        }else {
        imagen.kf.setImage(with: URL (string: imagenStr))
        }
        self.navigationItem.setHidesBackButton(true, animated: true)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cambiarImagenAction(_ sender: Any) {
        
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imagen.image = img
        self.dismiss(animated: true, completion: {
            self.upload (completion: { (imgString)  in
                //imagenPerfil.image = UIImage (named:"\(imgString)")
                
                self.imagenStr = imgString
                let usuarioNuevo = UsuarioNuevo(name: self.nombreStr, email: self.emailStr, pwd: self.contraseniaStr, img: self.imagenStr)
                alamofire.shared.nuevoUsuario(user: usuarioNuevo) {
                    print(usuarioNuevo)
                     }
            })
        })
    }
    
    
    
    func upload (completion: @escaping (_ user: String) -> Void){
    let headers: HTTPHeaders = [.contentType("application/json")]
        
        AF.upload(multipartFormData: { multipartFormData in multipartFormData.append((self.imagen.image?.jpegData(compressionQuality: 0.5))!, withName: "files" , fileName: "file.jpeg", mimeType: "image")
                },
              to: "http://192.168.2.3:8080/upload", method: .post , headers: headers).responseDecodable (of: RespuestaImagen.self) { response in
                         /*let data = response.data
                            let json = String(data: data!, encoding: String.Encoding.utf8)*/
            let imgString = response.value?.path
                        completion(imgString!)
            //imgString = self.imagen2
                        print(response.response?.statusCode)
                }
    }
    
}
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
extension HolaViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  // Discuss later
     }*/
