//
//  notesViewController.swift
//  Sandeep_c0766628_note_p1
//
//  Created by Owner on 2019-11-13.
//  Copyright © 2019 SandeepAppDev. All rights reserved.
//
import UIKit
protocol NotesViewControllerDelegate: class
{
    func didUpdatedNotes(folder: NotesFolder)
    func didMovedNotes(arrayfolder: [NotesFolder])
}
class NotesViewController: UIViewController
{
    //in notes view controller we need array to store the notes
    var folder = NotesFolder()
    var arrayFolders = [NotesFolder]()
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var deleteButton: UIBarButtonItem!
    @IBOutlet private weak var moveNotesButton: UIBarButtonItem!
    
    private var arraySelectedNotes = [String]()
    
    weak var delegate: NotesViewControllerDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "Notes"
    }
    //function to enabling the delete and move button
    @IBAction func EnableDeleteAndMoveButton(_ sender: Any)
    {
        self.deleteButton.isEnabled = !self.deleteButton.isEnabled
        self.moveNotesButton.isEnabled = !self.moveNotesButton.isEnabled
    }
    //create new note
    @IBAction func CreateNewNotes(_ sender: Any)
    {
        self.navigateToNoteViewController(note: "", isToEdit: false)
    }
    //segue to direct to note view controller
    func navigateToNoteViewController(note: String, isToEdit: Bool, index: Int = 0 )
    {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let noteViewController = storyBoard.instantiateViewController(withIdentifier: "NoteViewController") as! NoteViewController
        noteViewController.delegate = self
        noteViewController.note = note
        noteViewController.index = index
        noteViewController.isToEdit = isToEdit
        self.navigationController?.pushViewController(noteViewController, animated: true)
    }
    //delete button
    @IBAction func DeleteNotes(_ sender: Any)
    {
        guard arraySelectedNotes.count > 0 else
        {
            return
        }
        for selectedCell in arraySelectedNotes
        {
            let indexOfSelectedCell = self.folder.arrayNotes.firstIndex(of: selectedCell)
            self.folder.arrayNotes.remove(at: indexOfSelectedCell!)
            self.tableView.deleteRows(at: [IndexPath(row: indexOfSelectedCell!, section: 0)], with: .automatic)
        }
        self.arraySelectedNotes.removeAll()
        self.delegate?.didUpdatedNotes(folder: self.folder)
    }
    //action button to move the notes to the folder
    @IBAction func MoveNotesToFolder(_ sender: Any)
    {
        guard arraySelectedNotes.count > 0 else
        {
            return
        }
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let moveNotesViewController = storyBoard.instantiateViewController(withIdentifier: "MoveNotesViewController") as! MoveNotesViewController
        moveNotesViewController.arrayFolders = arrayFolders
        moveNotesViewController.arraySelectedNotes = arraySelectedNotes
        moveNotesViewController.delegate = self
        self.present(UINavigationController(rootViewController: moveNotesViewController) , animated: true, completion: nil)
    }
    
}
//Notes table view
extension NotesViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return folder.arrayNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.selectionStyle = .none
        
        if arraySelectedNotes.contains(folder.arrayNotes[indexPath.row]) {
            cell.accessoryType = .checkmark
        } else
        {
            cell.accessoryType = .detailButton
        }
        cell.textLabel?.text = folder.arrayNotes[indexPath.row]
        return cell
    }
}
// table view for notes cell configration
extension NotesViewController: UITableViewDelegate
{
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
{
        let cell = tableView.cellForRow(at: indexPath)
        
        if arraySelectedNotes.contains(folder.arrayNotes[indexPath.row])
        {
            let indexOfSelectedCell = arraySelectedNotes.firstIndex(of: folder.arrayNotes[indexPath.row])
            arraySelectedNotes.remove(at: indexOfSelectedCell!)
            cell!.accessoryType = .detailButton
        }
        else
        {
            arraySelectedNotes.append(folder.arrayNotes[indexPath.row])
            cell!.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath)
    {
        self.navigateToNoteViewController(note: self.folder.arrayNotes[indexPath.row], isToEdit: true, index: indexPath.row)
    }
}

extension NotesViewController: NoteViewControllerDelegate
{
    func editedNotes(note: String, index: Int)
    {
        self.folder.arrayNotes[index] = note
        self.tableView.reloadData()
        if let index = arrayFolders.firstIndex(where: { $0.name == folder.name })
        {
            arrayFolders[index] = folder
        }
        self.delegate?.didUpdatedNotes(folder: self.folder)
    }
    //notes will be added to table view taken from note text view
    func addedNotes(note: String)
    {
        self.folder.arrayNotes.append(note)
        self.tableView.reloadData()
        if let index = arrayFolders.firstIndex(where: { $0.name == folder.name })
        {
            arrayFolders[index] = folder
        }
        self.delegate?.didUpdatedNotes(folder: self.folder)
    }
}

extension NotesViewController: MoveNotesViewControllerDelegate
{
    func didMovedNotes(destinationFolder: NotesFolder)
    {
        
        if destinationFolder.name == self.folder.name
        {
            return
        }
        
        guard let sourceIndex = self.arrayFolders.firstIndex(where: { $0.name == self.folder.name }),
            let destinationIndex = self.arrayFolders.firstIndex(where: { $0.name == destinationFolder.name })  else
        {
                return
        }
        
        self.arrayFolders[destinationIndex].arrayNotes.append(contentsOf: self.arraySelectedNotes)
        
        for selectedCell in arraySelectedNotes
        {
            let indexOfSelectedCell = self.folder.arrayNotes.firstIndex(of: selectedCell)
            self.folder.arrayNotes.remove(at: indexOfSelectedCell!)
            self.tableView.deleteRows(at: [IndexPath(row: indexOfSelectedCell!, section: 0)], with: .automatic)
        }
        self.arraySelectedNotes.removeAll()
        self.arrayFolders[sourceIndex] = self.folder
        self.delegate?.didMovedNotes(arrayfolder: self.arrayFolders)
    }
}
