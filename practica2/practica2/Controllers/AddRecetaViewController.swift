//
//  AddRecetaViewController.swift
//  practica2
//
//  Created by Grisel Angelica Perez Quezada on 26/02/23.
//

import UIKit
import AVFoundation
import CoreData

class AddRecetaViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBAction func tapGestureDone(_ sender: Any) {
        tvTitle.endEditing(true)
        tvIngredientes.endEditing(true)
        tvPreparacion.endEditing(true)
    }
    
    @IBOutlet weak var tvTitle: UITextField!
    @IBOutlet weak var imgReceta: UIImageView!
    @IBOutlet weak var tvIngredientes: UITextView!
    @IBOutlet weak var tvPreparacion: UITextView!
    var imgPickCon : UIImagePickerController?
    let btnFoto = UIButton()
    
    var bebidas = [Receta]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        btnFoto.frame = CGRect(x:180, y:330, width:60, height:60)
        btnFoto.setImage(UIImage(systemName: "camera.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)), for: .normal)
        btnFoto.backgroundColor = .black
        btnFoto.tintColor = .white
        btnFoto.layer.cornerRadius = 25
        btnFoto.addTarget(self, action:#selector(addFoto), for:.touchUpInside)
        view.addSubview(btnFoto)
        setupTextFields()
        // Do any additional setup after loading the view.
    }
    
   
    @objc func addFoto() {
        imgPickCon = UIImagePickerController()
        imgPickCon?.delegate = self
        // si se permite la edición (recorte) de las imagenes
        imgPickCon?.allowsEditing = true
        //
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            switch AVCaptureDevice.authorizationStatus(for:.video) {
            case .authorized:self.launchIMGPC(.camera)
            case .notDetermined:AVCaptureDevice.requestAccess (for: .video) { permiso in
                                    if permiso {
                                        print("permiso",permiso)
                                        self.launchIMGPC(.camera)
                                    }
                                    else {
                                        self.launchIMGPC(.photoLibrary)
                                    }
                                }
            default:
                permisos()
                return
            }
        }
        else {
            self.launchIMGPC(.photoLibrary)
        }
    }
    
    
    func launchIMGPC (_ type:UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            self.imgPickCon?.sourceType = type
            print("llego?")
            self.present(self.imgPickCon!, animated: true)
        }
    }

    @IBAction func btnRegresar(_ sender: UIButton) {
       
        let story = UIStoryboard(name: "Main", bundle: nil)
             let controller = story.instantiateViewController(identifier: "inicio") as! ViewController
        controller.modalPresentationStyle = .fullScreen
             self.present(controller, animated: true, completion: nil)
    }
    @IBAction func save(_ sender: UIButton) {
        //salvando los datos
        //verificar si son vacios..no dejar pasar si si..ent-> todo ok guardamos
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let newReceta = Receta(context:managedContext)
        newReceta.img = tvTitle.text!+".jpg"
        newReceta.name = tvTitle.text
        newReceta.directions = tvPreparacion.text
        newReceta.ingredients = tvIngredientes.text
        
        bebidas.insert(newReceta, at: 0)
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext() // Save changes in CoreData
           //guardar la foto en documents
       
        saveImage(image: imgReceta.image!, name:tvTitle.text!)
        
       print("Datos guardados")
        //alert datos guardados
        let story = UIStoryboard(name: "Main", bundle: nil)
             let controller = story.instantiateViewController(identifier: "inicio") as! ViewController
        controller.modalPresentationStyle = .fullScreen
             self.present(controller, animated: true, completion: nil)
        
    }
    
    func saveImage(image:UIImage, name:String){
        
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            print("error")
            return
        }
        
        guard let path = FileManager.default.urls(for:.documentDirectory , in: .userDomainMask).first?.appendingPathComponent("\(name).jpg") else {
            print("error en la rura")
            return
        }
        
        do {
           try data.write(to: path)
            print("Imagen Guardada")
        }catch{
            print("Errosr al guardar foto.\(error)")
        }
        
        
    }
    
    func permisos () {
        let ac = UIAlertController(title: "", message:"Se requiere permiso para usar la cámara. Puede configurarlo desde settings ahora", preferredStyle: .alert)
        let action = UIAlertAction(title: "SI", style: .default) {
            alertaction in
            if let laURL = URL(string:UIApplication.openSettingsURLString) {
                UIApplication.shared.open(laURL)
            }
        }
        let action2 = UIAlertAction(title: "NO", style: .destructive)
        ac.addAction(action)
        ac.addAction(action2)
        self.present(ac, animated: true)
    }
    
    // MARK: - ImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // si NO se permite la edición (recorte) de las imagenes se usaria la llave .originalImage
        if let img = info[.editedImage] as? UIImage {
            imgReceta.image = img
            
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        imgReceta.image = UIImage()
    }
    
    @objc func endEditingText(){
        tvTitle.endEditing(true)
        tvIngredientes.endEditing(true)
        tvPreparacion.endEditing(true)
    }
    
    func setupTextFields(){
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButon = UIBarButtonItem(title:"DONE" , style: .done, target: self, action: #selector(endEditingText))
        
        toolbar.setItems([flexSpace,doneButon], animated: true)
        toolbar.sizeToFit()
        
        tvTitle.inputAccessoryView = toolbar
        tvIngredientes.inputAccessoryView = toolbar
        tvPreparacion.inputAccessoryView = toolbar
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
