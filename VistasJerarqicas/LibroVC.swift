//
//  LibroVC.swift
//  VistasJerarqicas
//
//  Created by Jose Navarro Alabarta on 27/1/16.
//  Copyright © 2016 ai2-upv. All rights reserved.
//

import UIKit
import CoreData

class LibroVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titulo: UITextView!
    @IBOutlet weak var autores: UITextView!
    @IBOutlet weak var portada: UIImageView!
    
    @IBOutlet weak var cISBN: UITextField!
    var titl = ""
    var aut = ""
    var cIsbn:String? =  nil
    
    
    var contexto : NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        cISBN.delegate = self
       
        if cIsbn != nil{
            //buscarLibro(cIsbn!)
            print("isbn recibido: \(cIsbn!)")
            self.cISBN.hidden = true
            consultarDDBB(cIsbn!)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func consultarDDBB (isbn: String){
        ////con esto sabemos si el elemento ha sido consultado o no realiza es xq la busqueda ya existe
        let vistaLIBRO = NSEntityDescription.entityForName("Libro", inManagedObjectContext: self.contexto!)
        let peticion = vistaLIBRO?.managedObjectModel.fetchRequestTemplateForName("Libros")
        
        // Explota xq no hay nada en la base de datos
        do {
            let consultaRecuperada = try self.contexto!.executeFetchRequest(peticion!)
            if (consultaRecuperada.count > 0) {
                
                var isbnC : String
                
                for cr in consultaRecuperada {
                     isbnC = cr.valueForKey("isbnl") as! String
                    if (isbnC == isbn) {
                        self.titulo.text = cr.valueForKey("titulol") as! String
                        cISBN.text! = isbnC
                        self.autores.text = cr.valueForKey("autorl") as! String
                        portada.image = cr.valueForKey("portadal") as? UIImage
                    }
                }
            }
        }catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            
        }
    
    
    
    }
    
    func textFieldShouldReturn(cISBN: UITextField) -> Bool {
        
        cISBN.resignFirstResponder()
        
        
        
        
        
        buscarLibro(cISBN.text!)
        return true
    }
    
    func buscarLibro(isbn: String){
    
        //bloque no bloqueante
        let link = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
        let url = NSURL(string: link) // conversion de la string a formato url
        let datos = NSData(contentsOfURL: url!) // se realiza la peticion al servidor
        
        
        
        
        if datos != nil {
            //revisar
            do{
                //bloqye de codigo
                let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                
                let isb = "ISBN:\(isbn)"
                
                let dico1 = json as! NSDictionary
                
                if (dico1.count > 0) {
                    
                    let dico2 = dico1.valueForKey(isb) as! NSDictionary
                    
                    self.titulo.text =  dico2.valueForKey("title") as! NSString as String
                    
                    
                    //imagen
                    if (dico2["cover"] != nil ) {
                        let dico3 = dico2.valueForKey("cover") as! NSDictionary
                        let rutaImagen = dico3.valueForKey("small") as! NSString as String
                        let urlImagen :NSURL = NSURL(string: rutaImagen)!
                        let dataImage:NSData = NSData(contentsOfURL:urlImagen)!
                        portada.image = UIImage(data: dataImage)
                    }
                    
                    //autores
                    var dico4 = dico2.valueForKey("authors") as! [NSDictionary]
                    self.autores.text = dico4.removeAtIndex(0).valueForKey("name")! as! String
                    
                    let entidadLibro = NSEntityDescription.insertNewObjectForEntityForName("Libro", inManagedObjectContext: self.contexto!)
                    //anyadir en la tabla Libro
                    entidadLibro.setValue(isbn, forKey: "isbnl")
                    entidadLibro.setValue(self.autores.text, forKey: "autorl")
                    if portada.image != nil {
                        entidadLibro.setValue(UIImagePNGRepresentation(portada.image!), forKey: "portadal")
                    }
                    entidadLibro.setValue(self.titulo.text, forKey: "titulol")
                    
                    //paso de contexto a base de datos
                    do {
                        try self.contexto!.save()
                    }catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                    
                }else{
                    
                    let alertController = UIAlertController(title: "Error", message: "ISBN introduccido no existe.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
            catch _ {
                //no se captura nada
            }
        }else {
            let alertController = UIAlertController(title: "Error", message: "Ha habido un problema conectando con el servidor. Revisa tu conexión a internet y vuelve a intentarlo.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
