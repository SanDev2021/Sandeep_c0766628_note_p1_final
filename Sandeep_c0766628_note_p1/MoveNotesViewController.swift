//
//  MoveNotesViewController.swift
//  Sandeep_c0766628_note_p1
//
//  Created by Owner on 2019-11-13.
//  Copyright © 2019 SandeepAppDev. All rights reserved.
//


import UIKit

protocol MoveNotesViewControllerDelegate: class
{
    func didMovedNotes(destinationFolder: NotesFolder)
}

class MoveNotesViewController: UIViewController
{
    
    @IBOutlet private weak var tableView: UITableView!
    //array to hold moved notes to sprcific folder
    var arrayFolders = [NotesFolder]()
    var arraySelectedNotes = [String]()
    
    weak var delegate: MoveNotesViewControllerDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = "Move to folder..."
    }
    
    @IBAction func methodToDismissView(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
//moving notes after pressing (more) button

extension MoveNotesViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrayFolders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        cell.textLabel?.text = arrayFolders[indexPath.row].name
        
        return cell
    }
}

extension MoveNotesViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        //allert to asking the user if he wants to move the notes to desired folder
        let alertController = UIAlertController(title: "Move to \(self.arrayFolders[indexPath.row].name)", message: "Are you sure?", preferredStyle: .alert)
        //Move folders
        let moveAction = UIAlertAction(title: "Move", style: .destructive, handler: { alert -> Void in
            self.delegate?.didMovedNotes(destinationFolder: self.arrayFolders[indexPath.row])
            self.dismiss(animated: true, completion: nil)
        })
        //if NO is slected by user
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(cancelAction)
        alertController.addAction(moveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
