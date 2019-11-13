//
//  foldersViewController.swift
//  Sandeep_c0766628_note_p1
//
//  Created by Owner on 2019-11-13.
//  Copyright © 2019 SandeepAppDev. All rights reserved.
//


import UIKit

struct NotesFolder
{
    var name = String()
    var arrayNotes = [String]()
}

class FoldersTableViewCell: UITableViewCell
{
    //label to show the number of notes in the folder
    @IBOutlet weak var numberOfNotesLabel: UILabel!
}

class FoldersViewController: UIViewController
{
    
    @IBOutlet private weak var editButton: UIBarButtonItem!
    // array to hold the folders
    var Folders = [NotesFolder]()
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //setting title of the view
        self.title = "Folders"
    }
    //creating folder with taking action by the new folder button
    @IBAction func createNewFolder(_ sender: Any)
    {
        let alertController = UIAlertController(title: "New Folder", message: "Enter a name for this folder.", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Name"
        }
        let saveAction = UIAlertAction(title: "Add Item", style: .default, handler: { alert -> Void in
            let nameTextField = alertController.textFields![0] as UITextField
            guard let folderName = nameTextField.text else
            {
                return
            }
            
            if self.Folders.contains(where: { $0.name ==  folderName })
            {
                //show alert if same name is tried to give to the folder
                self.showAlertForDuplicateFolder(folderName: folderName)
                return
            }
            
            let folder = NotesFolder(name: folderName, arrayNotes: [])
            
            self.Folders.append(folder)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive , handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    //show alert if dupliacte name is tried to give to the folder
    func showAlertForDuplicateFolder(folderName: String)
    {
        let alertController = UIAlertController(title: "Name Taken", message: "Please choose a different name.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    //edit button actions
    @IBAction func startEditing(_ sender: Any)
    {
        
        editButton.title = editButton.title == "Edit" ? "Done" : "Edit"
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
}
//Folders table view
extension FoldersViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! FoldersTableViewCell
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        cell.imageView?.image = UIImage(named: "folder-icon")
        cell.textLabel?.text = Folders[indexPath.row].name
        //number of notes shown in the folder
        cell.numberOfNotesLabel.text = String(describing: Folders[indexPath.row].arrayNotes.count)
        
        return cell
    }
}

extension FoldersViewController: UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Folders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    //edit button converting to done with these method
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath)
    {
        self.editButton.title = "Done"
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?)
    {
        self.editButton.title = "Edit"
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    //swaping the folders
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        let folderToMove = Folders[sourceIndexPath.row]
        
        Folders.insert(folderToMove, at: destinationIndexPath.row)
        Folders.remove(at: sourceIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let notesViewController = storyBoard.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        notesViewController.folder = Folders[indexPath.row]
        notesViewController.arrayFolders = Folders
        notesViewController.delegate = self
        self.navigationController?.pushViewController(notesViewController, animated: true)
    }
}

extension FoldersViewController: NotesViewControllerDelegate
{
    func didMovedNotes(arrayfolder: [NotesFolder])
    {
        self.Folders = arrayfolder
        self.tableView.reloadData()
    }
    //after deleting or moving notes the table vew will be reload 
    func didUpdatedNotes(folder: NotesFolder)
    {
        if let index = Folders.firstIndex(where: { $0.name == folder.name })
        {
            Folders[index] = folder
            self.tableView.reloadData()
        }
    }
}

