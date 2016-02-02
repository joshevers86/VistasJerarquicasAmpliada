//
//  ListaLibrosTVC.swift
//  VistasJerarqicas
//
//  Created by Jose Navarro Alabarta on 27/1/16.
//  Copyright © 2016 ai2-upv. All rights reserved.
//

import UIKit

class ListaLibrosTVC: UITableViewController {
    
    
    @IBOutlet weak var vistaLibros: UITableView!
    var libros : [[String]] = [[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Lista de Libros"
        self.vistaLibros.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .Plain, target: self, action: "buscarPorISBN")
        //esto cambiar
        
        self.libros.append(["Cien años de soledad", "978-84-376-0494-7"])
        self.libros.append(["Scenes of clerical life", "0140430873"])
        self.libros.append(["The Trojan women", "9780393002034"])
        self.libros.append(["El alquimista", "0062511408"])
        

        self.vistaLibros.reloadData()
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
        }
    }

    
    func buscarPorISBN() {
        performSegueWithIdentifier("obtenerLibro", sender: self)
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        
        let lvc = segue.sourceViewController as! LibroVC
        print("return \(lvc.cISBN.text!)")
        if (lvc.cISBN.text! != "" ) {
            self.libros.append([lvc.titulo.text!,lvc.cISBN.text!])
        }
        self.vistaLibros.reloadData()
    }
    
}
