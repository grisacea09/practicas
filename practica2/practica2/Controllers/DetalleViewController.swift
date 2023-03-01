//
//  DetalleViewController.swift
//  practica2
//
//  Created by Grisel Angelica Perez Quezada on 26/02/23.
//

import UIKit

class DetalleViewController: UIViewController {
    
    var selectedDrink: bebida?
    
    @IBOutlet weak var txTitle: UILabel!
    
    @IBOutlet weak var detailImage: UIImageView!
    
    @IBOutlet weak var txDetail: UITextView!
    
    
    @IBOutlet weak var txPreparacion: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view.
        guard let selDrink = selectedDrink else{ return }
        DispatchQueue.main.async {
            self.descargarJson(name: selDrink.img)
        }
        txTitle.text = selDrink.name
        txTitle.font = UIFont(name: "BERNIERShade-Regular", size: 35)
        txDetail.text = selDrink.ingredients
        txDetail.font = UIFont(name: "BERNIERShade-Regular", size: 20)
        txPreparacion.text = selDrink.directions
        txPreparacion.font = UIFont(name: "BERNIERShade-Regular", size: 20)
 
    }

    func descargarJson(name:String){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
      
        if let pathComponent = url.appendingPathComponent(name) {
               
                let filePath = pathComponent.path
                let fileManager = FileManager.default
            
                if fileManager.fileExists(atPath: filePath) {
                    print("FILE AVAILABLE")
                   
                    if let documentsURL = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)
                        .first {
                        let readPath = documentsURL.appendingPathComponent(name, isDirectory: false)
                        detailImage.image  = UIImage(contentsOfFile: readPath.path)
                        
                        print("Se ha guardado la imagen")
                    }
                    
                    //detailImage.image = UIImage()
                    
                } else {
                    if NetMonitor.shared.isConnected {
                    print("FILE NOT AVAILABLE ent descargalo ",name)
                    var Ws = "http://janzelaznog.com/DDAM/iOS/drinksimages/"+name
                    guard let laURL = URL(string: Ws) else { return }
                    print(laURL)
                    do{
                        let bytes = try Data(contentsOf: laURL)
                        print(bytes)
                        if let documentsURL = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)
                            .first {
                            try bytes.write(to:documentsURL.appendingPathComponent(name), options: .atomic)
                            print("Se ha guardado la imagen")
                            
                        }
                        //let tmp = try JSONSerialization.jsonObject(with: bytes, options: .fragmentsAllowed)
                        detailImage.image  = UIImage(data: bytes)
                    }
                    catch{
                        print("Ocurrio error al guardar \(String(describing: error))")
                    }
                    
                }else{
                    DispatchQueue.main.async { [self] in
                        userMessage(title:"Sin conexión a Internet", msg:"No cuentas con internet",salir: 0)
                        detailImage.image = UIImage(systemName: "wifi.slash")
                        
                    }
                }// fin else netMonitor
                    
                }// fin else
            
            }// fin pathcomponent
            else {
                print("FILE PATH NOT AVAILABLE")
            }
        
        
        //hay que verificar si existe el archivo y si no...todo eso-->
       
        
    }
    
    func userMessage(title:String, msg:String, salir:Int){
        // create the alert
                let alert = UIAlertController(title: title
, message: msg
, preferredStyle: UIAlertController.Style.alert)

        let action = UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: { action in
            if(salir == 1){
                exit(0)
            }}
            )
            
            
                // add an action (button)
                alert.addAction(action)

                // show the alert
                self.present(alert, animated: true, completion: nil)
    }

}
