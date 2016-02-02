//
//  LibroVC.swift
//  VistasJerarqicas
//
//  Created by Jose Navarro Alabarta on 27/1/16.
//  Copyright © 2016 ai2-upv. All rights reserved.
//

import UIKit

class LibroVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var titulo: UITextView!
    @IBOutlet weak var autores: UITextView!
    @IBOutlet weak var portada: UIImageView!
    
    @IBOutlet weak var cISBN: UITextField!
    var titl = ""
    var aut = ""
    var cIsbn:String? =  nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cISBN.delegate = self
       
        if cIsbn != nil{
            buscarLibro(cIsbn!)
            self.cISBN.hidden = true
        }
        // Do any additional setup after loading the view.
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
