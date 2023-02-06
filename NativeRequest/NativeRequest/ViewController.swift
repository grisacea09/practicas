//
//  ViewController.swift
//  NativeRequest
//
//  Created by Ángel González on 04/02/23.
//

import UIKit

class ViewController: UIViewController {

    var character : Result?
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
  
   
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view.
        guard let char = character else{ return }

        
        
        let urlSessionConfiguration = URLSessionConfiguration.ephemeral
        let urlSession = URLSession(configuration: urlSessionConfiguration)
           guard let laUrl = URL(string: char.image) else{ return}
            let urlRequest: URLRequest = URLRequest(url: laUrl)
        print(laUrl)
        urlSession.dataTask(with: urlRequest) { data, response, error in
                          // Qué haremos cuando obtengamos una repuesta
                          if error == nil {
                             guard let imageData: Data = data else { return }
                              DispatchQueue.main.async { [self] in
                                //self.imageContainer.image = UIImage(data: imageData)
                                 
                                  self.imagen.image = UIImage(data: imageData)
                                  self.genderLabel.text = "Genero: "+char.gender.rawValue
                                  self.nameLabel.text = "Nombre: "+char.name
                                  self.statusLabel.text = "Estatus: "+char.status.rawValue
                                  
                             }
                          }
                       }
                       // 5. Iniciamos tarea
                       .resume()
            
            
       
        
    }


}

