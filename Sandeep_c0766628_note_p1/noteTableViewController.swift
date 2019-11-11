//
//  noteTableViewController.swift
//  Sandeep_c0766628_note_p1
//
//  Created by MacStudent on 2019-11-11.
//  Copyright © 2019 SandeepAppDev. All rights reserved.
//

import UIKit

class noteTableViewController: UITableViewController {
    
    var folders : [String] = []
     var count : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
       // tableView.dataSource = self
       // tableView.delegate = self as? UITableViewDelegate
        //enable the editing mode for the UITable view
        //self.tableView.isEditing = true
        //navigation on right of the row
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

//enabling the edit mode cause delete button to be visible for all the cells .
   //disable the button by implementing these methods
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing{
        
                return .none
        
            }
            else{
        
                return .delete
            }
    }
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool
    {
        return false
    }
  
//creating cell in th table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
{
    return folders.count
}
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
    cell?.textLabel?.text = folders[indexPath.row]
    //creating accesory icon in cell
    cell?.imageView?.image = UIImage(named: "folder-icon.jpg")
        return cell!
}

//new folder button pressed
    @IBAction func newFolderPrerssed(_ sender: UIBarButtonItem)
    {
    let alert = UIAlertController(title: "New Folder", message: "Enter a name for this folder", preferredStyle: .alert)
       alert.addTextField {(UITextField) in
       }
       alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
      self.present(alert, animated: true, completion: nil)
      alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (UIAlertAction) in
          let content = alert.textFields![0] as UITextField
         self.folders.append(content.text!)
          self.tableView.reloadData()
      }))
      }
//deleting the folders from table view
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
if editingStyle == .delete
{
            folders.remove(at: indexPath.row)
        }
        tableView.reloadData()
    }
   //creating folders in the table

    override func tableView(_ tableView: UITableView, canMoveRowAt IndexPath: IndexPath) -> Bool
        {
        return true
        }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let rowToMove = folders[sourceIndexPath.row]
        folders.remove(at: sourceIndexPath.row)
        folders.insert(rowToMove, at: destinationIndexPath.row)
}
}
