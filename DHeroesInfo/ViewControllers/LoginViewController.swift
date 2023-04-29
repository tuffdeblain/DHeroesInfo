//
//  LoginViewController.swift
//  DHeroesInfo
//
//  Created by Сергей Кудинов on 28.04.2023.
//

import UIKit
import CoreData

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var idHistoryTableView: UITableView!
    @IBOutlet weak var steamIDTextField: UITextField!

    var savedSteamIDs: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        idHistoryTableView.dataSource = self
        idHistoryTableView.delegate = self
        loadSavedSteamIDs()
        idHistoryTableView.backgroundColor =  UIColor(red: 0.11, green: 0.16, blue: 0.22, alpha: 1.0)
    }

    @IBAction func nextViewButton(_ steamID: String? = nil) {
        let idToUse = steamID ?? steamIDTextField.text
        if checkTextField(textField: steamIDTextField) || steamID != nil {
            performSegue(withIdentifier: "profileSegue", sender: idToUse)
        }
    }

}

extension LoginViewController {
    private func checkTextField(textField: UITextField) -> Bool {
        if textField.text == nil || textField.text == "" {
            return false
        } else { return true }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let profileVC = segue.destination as? ProfileViewController, let steamID = sender as? String else { return }
        profileVC.steamID = steamID
    }

    
    func steamIDExists(steamID: String) -> Bool {
        for savedSteamID in savedSteamIDs {
            if let savedID = savedSteamID.value(forKey: "steamID") as? String, savedID == steamID {
                return true
            }
        }
        return false
    }
    
    func saveSteamID(steamID: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SteamID", in: managedContext)!
        let newSteamID = NSManagedObject(entity: entity, insertInto: managedContext)
        
        newSteamID.setValue(steamID, forKey: "steamID")
        
        do {
            try managedContext.save()
            savedSteamIDs.append(newSteamID)
            idHistoryTableView.reloadData()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func loadSavedSteamIDs() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SteamID")
        
        do {
            savedSteamIDs = try managedContext.fetch(fetchRequest)
            idHistoryTableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

extension LoginViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedSteamIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "steamIDCell", for: indexPath)
        let steamID = savedSteamIDs[indexPath.row]
        cell.textLabel?.text = steamID.value(forKey: "steamID") as? String
        cell.backgroundColor =  UIColor(red: 0.11, green: 0.16, blue: 0.22, alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let steamID = savedSteamIDs[indexPath.row]
        if let selectedSteamID = steamID.value(forKey: "steamID") as? String {
            nextViewButton(selectedSteamID)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(savedSteamIDs[indexPath.row])
            savedSteamIDs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not delete. \(error), \(error.userInfo)")
            }
        }
    }
}
