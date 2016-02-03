//
//  ListaLibrosTVC.swift
//  VistasJerarqicas
//
//  Created by Jose Navarro Alabarta on 27/1/16.
//  Copyright © 2016 ai2-upv. All rights reserved.
//

/*

En este entregable desarrollarás una aplicación usando Xcode que realice una petición a https://openlibrary.org/ y que muestre el resultado en una tabla jerárquica a dos niveles En el primer nivel se encontrará una vista tabla, mostrando los títulos de libros ya buscados. Al momento de seleccionar uno de los renglones de la tabla, el detalle del libro deberá ser mostrado.

La idea es que los libros que se vayan buscando se vayan integrando la estructura que representará la fuente de datos de la vista tabla.

Puedes seleccionar, al momento de crear tu proyecto la plantilla Maestro-Detalle. De esta manera se facilita la codificación de tu aplicación

IMPORTANTE. AL momento de crear tu proyecto, no olvides seleccionar el uso de Core Data ya que se usará en ese módulo y así se facilitan las cosas.


1 Al iniciar la aplicación, una vista tabla deberá ser mostrada

2. Deberá contener un UIBarButtonItem, en específico el Add (signo +) en la barra de navegación que permita hacer una búsqueda y añadir el libro a la tabla

3. Al presionar el botón de añadir (punto anterior), se deberá mostrar una vista que permita ingresar el ISBN de un libro y mostrar, en caso de éxito de la búsqueda:

    El título del libro
    Los autores del libro
    La portada (en caso de que se encuentre)

4. Al regresar a la vista tabla, el título del libro buscado deberá aparecer en la tabla

5. Si seleccionamos un renglón de la tabla que contenga un título de libro, deberá mostrar sus detalles


------------------Ampliacion----------


Además de lo establecido en el entregable anterior, deberá incluir persistencia de datos, es decir (se repite la descripción del entregable anterior por conveniencia),

En este entregable desarrollarás una aplicación usando Xcode que realice una petición a https://openlibrary.org/ y que muestre el resultado en una tabla jerárquica a dos niveles En el primer nivel se encontrará una vista tabla, mostrando los títulos de libros ya buscados. Al momento de seleccionar uno de los renglones de la tabla, el detalle del libro deberá ser mostrado.

La idea es que los libros que se vayan buscando se vayan integrando la estructura que representará la fuente de datos de la vista tabla.

Puedes seleccionar, al momento de crear tu proyecto la plantilla Maestro-Detalle. De esta manera se facilita la codificación de tu aplicación

IMPORTANTE. AL momento de crear tu proyecto, no olvides seleccionar el uso de Core Data ya que se usará en ese módulo y así se facilitan las cosas

ADICIONALMENTE, utilizarás los conceptos de Core Data para hacer persistir los datos de la búsqueda de libros.


1 Al iniciar la aplicación, una vista tabla deberá ser mostrada      

2. Deberá contener un UIBarButtonItem, en específico el Add (signo +) en la barra de navegación que permita hacer una búsqueda y añadir el libro a la tabla   

3. Al presionar el botón de añadir (punto anterior), se deberá mostrar una vista que permita ingresar el ISBN de un libro y mostrar, en caso de éxito de la búsqueda:  

    · El título del libro    

    · Los autores del libro      

    · La portada (en caso de que se encuentre)   

4. Al regresar a la vista tabla, el título del libro buscado deberá aparecer en la tabla     

5. Si seleccionamos un renglón de la tabla que contenga un título de libro, deberá mostrar sus detalles      

6. Deberá haber un esquema de datos que muestre las entidades y sus relaciones que serán necesarias para almacenar los datos resultado de una búsqueda de un libro por su ISBN

7 Al relanzar la aplicación la vista tabla deberá mostrar los títulos de los libros que fueron el resultado de búsquedas anteriores

*/



import UIKit
import CoreData

class ListaLibrosTVC: UITableViewController {
    
    
    @IBOutlet weak var vistaLibros: UITableView!
    var libros : [[String]] = [[String]]()
    var contexto : NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Lista de Libros"
        self.vistaLibros.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .Plain, target: self, action: "buscarPorISBN")
        
        
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        obtenerDatosBBDD()
      
        /***/
        

        //esto cambiar
        
/*        self.libros.append(["Cien años de soledad", "978-84-376-0494-7"])
        self.libros.append(["Scenes of clerical life", "0140430873"])
        self.libros.append(["The Trojan women", "9780393002034"])
        self.libros.append(["El alquimista", "0062511408"])
        Harry Potter , 9780563533177
        */
        

        //self.vistaLibros.reloadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.libros.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Celda", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.libros[indexPath.row][0]
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let lvc = segue.destinationViewController as! LibroVC
        lvc.cIsbn = nil
        if let ip = self.vistaLibros.indexPathForSelectedRow {
            lvc.cIsbn = self.libros[ip.row][1]
            print("isbn seleccionado: \(lvc.cIsbn)")
        }
    }

    
    func buscarPorISBN() {
        performSegueWithIdentifier("obtenerLibro", sender: self)
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        
        /*let lvc = segue.sourceViewController as! LibroVC
        print("return \(lvc.cISBN.text!)")
        if (lvc.cISBN.text! != "" ) {
            self.libros.append([lvc.titulo.text!,lvc.cISBN.text!])
        }*/
        self.libros.removeAll()
        obtenerDatosBBDD()
        self.vistaLibros.reloadData()
    }
    
    func obtenerDatosBBDD () {
        let entidadLibro = NSEntityDescription.entityForName("Libro", inManagedObjectContext: self.contexto!)
        let consultaLibros = entidadLibro?.managedObjectModel.fetchRequestTemplateForName("Libros")
        
        do {
            let consultaRecuperada = try self.contexto.executeFetchRequest(consultaLibros!)
            if (consultaRecuperada.count > 0) {
                for (var i = 0 ; i < consultaRecuperada.count ; i++){
                    let titulo = consultaRecuperada[i].valueForKey("titulol") as! String
                    let isbn = consultaRecuperada[i].valueForKey("isbnl") as! String
                    //let autor = cr.valueForKey("autorl") as! [String]
                    //let portada = cr.valueForKey("portadal") as! [String]
                    
                        self.libros.append([titulo, isbn])
                }
            }
        }catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
            
        }
    }
}
