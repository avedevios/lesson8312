//
//  ViewController.swift
//  lesson8312
//
//  Created by ake11a on 2022-10-22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var notesTableView: UITableView!
    
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        notesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "note_cell")
        
        notesTableView.dataSource = self
        //notesTableView.delegate = self
        
        createAddButton()
    }
   
    private func createAddButton() {
        
        view.addSubview(addButton)
        
        addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        //addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private lazy var addButton: UIButton = {
        let addButton = UIButton()
        
        addButton.backgroundColor = .green
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = .boldSystemFont(ofSize: 40)
        addButton.layer.cornerRadius = 50 / 2
        addButton.addTarget(self, action: #selector(addNote), for: .touchUpInside)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        return addButton
    }()
    
    @objc func addNote() {
       
        let alertController = UIAlertController(title: "New note", message: "Type what you need", preferredStyle: .alert)
        
        var noteTextField = UITextField()
        
        alertController.addTextField { text in
            noteTextField = text
        }
        
        let actionOk = UIAlertAction(title: "Ok", style: .cancel) { action in
            
            let inputText = noteTextField.text!
            if inputText != "" {
                let newNote = Note(text: inputText, checked: false)
                self.notes.append(newNote)
                
                self.notesTableView.reloadData()
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive) { action in
            ()
        }
        
        alertController.addAction(actionOk)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
        
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "note_cell")
        cell.textLabel?.text = notes[indexPath.row].text
        
        if notes[indexPath.row].checked {
            cell.imageView?.image = UIImage(named: "checkBoxSet")
        } else {
            cell.imageView?.image = UIImage(named: "checkBox")
        }
        
        cell.imageView?.isUserInteractionEnabled = true
        let  tap = CustomTapGestureRecognizer(target: self, action: #selector(checkBoxSet(sender:)))
        tap.noteIndex = indexPath.row
        
        cell.imageView?.addGestureRecognizer(tap)
        
        return cell
    }
    
    class CustomTapGestureRecognizer: UITapGestureRecognizer {
        var noteIndex: Int?
    }
    
    @objc func checkBoxSet(sender: CustomTapGestureRecognizer) {
       
        if !notes[sender.noteIndex!].checked {
            notes[sender.noteIndex!].checked = true
            
            notes.sort { (lhs: Note, rhs: Note) -> Bool in
                // you can have additional code here
                return lhs.checked
            }
            
            notesTableView.reloadData()
        }
    }
}

//extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        return 450
//    }
//}
