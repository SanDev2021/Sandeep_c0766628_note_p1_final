////
//  ViewController.swift
//  sandeep_c0766628_note_p1
//
//  Created by Owner on 2019-11-09.
//  Copyright © 2019 SandeepAppDev. All rights reserved.
//
import UIKit

class ViewController: UIViewController,UITableViewDataSource, UITabBarDelegate {
    //creating array to hold user input
   
    var folders : [String] = []
    var count : Int = 1
    @IBOutlet weak var newFolderButton: UIButton!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self as? UITableViewDelegate
        
        //enable the editing mode for the UITable view
        self.tableView.isEditing = false
        //navigation on right of the row
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    //enabling the edit mode cause delete button to be visible for all the cells .
    //disable the button by implementing these methods
   func tableView(_tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
     return .none}
     func tableView(_ tableView: UITableView, shoundIndentWhileEditingRowAt indexPath: IndexPath) -> Bool{
     return false}
     
    //creating cell in th table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = folders[indexPath.row]
        //creating accesory icon in cell
        
        cell?.imageView?.image = UIImage(named: "folder-icon.jpg")
        return cell!
    }
    // after pressing new folder getting the folder name from user
    @IBAction func newFolderPressed(_ sender: UIButton)
    {
        
        let alert = UIAlertController(title: "New Folder", message: "Enter a name for this folder", preferredStyle: .alert)
        alert.addTextField {(UITextField) in
        }
        alert.addAction(UIAlertAction(title: "Add Item", style: .default, handler: { (UIAlertAction) in
            let content = alert.textFields![0] as UITextField
            self.folders.append(content.text!)
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //deleting the folders from table view
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            folders.remove(at: indexPath.row)
        }
        tableView.reloadData()
    }
    // swaping the cells after pressing edit bar button on the top right
    @IBAction func startEditing(_ sender: UIBarButtonItem) {
    
        isEditing = !isEditing
        self.tableView.isEditing = !self.tableView.isEditing
    }
        func tableView(_ tableView: UITableView, canMoveRowAt IndexPath: IndexPath) -> Bool {
        return true
        
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let rowToMove = folders[sourceIndexPath.row]
        folders.remove(at: sourceIndexPath.row)
        folders.insert(rowToMove, at: destinationIndexPath.row)
}
    
}





