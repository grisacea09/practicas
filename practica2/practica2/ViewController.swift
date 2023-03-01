//
//  ViewController.swift
//  practica2
//
//  Created by Grisel Angelica Perez Quezada on 22/02/23.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    var bebidas:[bebida] = []
    var selectIndex: Int = 0
    var recetaBebida = [Receta]()
   

    private let collectionViewDrinks: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //layout.itemSize = .init(width: 200, height: 200)
        
        let numberofCells = 2
        
               let width = (UIScreen.main.bounds.width - CGFloat((numberofCells - 1) * 10)) / CGFloat(numberofCells)
              
               layout.scrollDirection = .vertical // .horizontal
               layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
               layout.minimumLineSpacing = 5
               layout.minimumInteritemSpacing = 5
               layout.itemSize = CGSize(width: width, height: width)
        
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
        
        if NetMonitor.shared.isConnected {
        }
        else{
            DispatchQueue.main.async { [self] in
                userMessage(title:"Sin conexión a Internet", msg:"No cuentas con internet",salir: 1)
                //exit(0)
            }
        }
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // consultar el API y serializar el JSON
        print("entro")
        if NetMonitor.shared.isConnected {
            print("entro2")
            let urlSessionConfiguration = URLSessionConfiguration.ephemeral
          
            //config.waitsForConnectivity = true
            urlSessionConfiguration.timeoutIntervalForRequest = 30
            urlSessionConfiguration.timeoutIntervalForResource = 30
            let urlSession = URLSession(configuration: urlSessionConfiguration)
            guard let laUrl = URL(string: "http://janzelaznog.com/DDAM/iOS/drinks.json") else{ return}
            print(laUrl)
            
            
            var urlRequest: URLRequest = URLRequest(url: laUrl)
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            urlSession.dataTask(with: urlRequest) { data, response, error in
                // Qué haremos cuando obtengamos una repuesta
                if error == nil {
                    
                    guard let datas = data,  let resp = response as? HTTPURLResponse else {
                       // print("no hay internet datas")
                        
                        return
                    }
                    DispatchQueue.main.async { [self] in
                        
                        do {
                            bebidas = try JSONDecoder().decode([bebida].self, from: datas)
                            
                            print(bebidas)
                            getBebidas()
                            
                            collectionViewDrinks.backgroundColor = .systemTeal
                            collectionViewDrinks.dataSource = self
                            collectionViewDrinks.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionCell")
                            view.addSubview(collectionViewDrinks)
                            
                            NSLayoutConstraint.activate([
                                collectionViewDrinks.topAnchor.constraint(equalTo: view.topAnchor),
                                collectionViewDrinks.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                collectionViewDrinks.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                collectionViewDrinks.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                            ])
                            
                            collectionViewDrinks.delegate = self
                            
                            let floatingButton = UIButton()
                            //floatingButton.setTitle("square.and.arrow.up.fill", for: .normal)
                            floatingButton.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)), for: .normal)
                            floatingButton.backgroundColor = .black
                            floatingButton.tintColor = .white
                            floatingButton.layer.cornerRadius = 25
                            floatingButton.addTarget(self, action:#selector(btnAddTouch), for:.touchUpInside)
                            view.addSubview(floatingButton)
                            
                            floatingButton.translatesAutoresizingMaskIntoConstraints = false
                            floatingButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
                            floatingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
                            floatingButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                            floatingButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
                            
                        } catch let error {
                            
                            print("Ha ocurrido un error:\(error.localizedDescription)")
                            
                        }
                        
                        
                        
                        
                    }
                }else{
                    print("error")
                    DispatchQueue.main.async { [self] in
                        self.userMessage(title:"Sin conexión a Internet", msg:"No cuentas con internet, tus datos son insuficientes",salir: 1)
                    }
                }
            }
            // 5. Iniciamos tarea
            .resume()
        }
        else{
            userMessage(title:"Sin conexión a Internet", msg:"No cuentas con internet",salir: 1)
        }
            
                
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
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("dese array", bebidas.count)
        return bebidas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(CustomCellCollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionCell", for: indexPath) as! CustomCellCollectionViewCell
        //cell.backgroundColor = .orange
        //necesito una celda customizada
        //cell.nameLabel.font = UIFont(name:"PingFangTC-Regular" , size: 22)
       // cell. = UIFont(name:"BronwishAlbilone" , size: 12)
        let model = bebidas[indexPath.row]
        
        
        var listContentConfiguration = UIListContentConfiguration.cell()
       // listContentConfiguration.image =
        listContentConfiguration.text = model.name
      
        cell.contentConfiguration = listContentConfiguration
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
         let cell = collectionView.cellForItem(at: indexPath) as? UICollectionViewCell
                print(indexPath.row, bebidas[indexPath.row])
        selectIndex = indexPath.row
        performSegue(withIdentifier: "detalle", sender: nil)
        //debo presentar el otro VC de detalle
        
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! DetalleViewController
        
        if segue.identifier == "detalle" {
            let destination = segue.destination as! DetalleViewController
            destination.selectedDrink = bebidas[selectIndex]
        }
    }
   
    
    @objc func btnAddTouch() {
        print("click ir a añadir receta")
        //deberia ir al otro controller
        let story = UIStoryboard(name: "Main", bundle: nil)
             let controller = story.instantiateViewController(identifier: "addReceta") as! AddRecetaViewController
        controller.modalPresentationStyle = .fullScreen
             self.present(controller, animated: true, completion: nil)
        
       
    }
    
    
    func getBebidas() {
        let bebidaFetch: NSFetchRequest<Receta> = Receta.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(Receta.name), ascending: false)
        bebidaFetch.sortDescriptors = [sortByName]
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(bebidaFetch)
            recetaBebida = results
            print("cuantos?",recetaBebida.count)
            print(recetaBebida)
            //como le hacemos para que no se repita??
           var cuantasJson = 15
            var cuantasBD = recetaBebida.count
            var total = cuantasJson + cuantasBD
            
            for item in recetaBebida {
                var b = bebida(directions: item.directions!,ingredients: item.ingredients!,name:item.name!,img: item.img!)
                if(bebidas.count < total){
                    bebidas.append(b)
                }
                else{
                    print("ya fueron añadidas")
                }
                
            }
            //recetaBebida[0].name
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
   
  

}

