//
//  LoginViewController.swift
//  DHeroesInfo
//
//  Created by Сергей Кудинов on 28.04.2023.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var idHistoryTableView: UITableView!
    @IBOutlet weak var steamIDTextField: UITextField!

    var savedSteamIDs: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadSavedSteamIDs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedSteamIDs()
    }

    @IBAction func nextViewButton() {
        guard let enteredSteamID = steamIDTextField.text, checkTextField(textField: steamIDTextField), isValidSteamID32(enteredSteamID) else {
            showAlertForInvalidSteamID()
            return
        }
        saveSteamIDIfNotExists(steamID: enteredSteamID)
        performSegue(withIdentifier: "profileSegue", sender: enteredSteamID)
    }
    
    private func setupTableView() {
        idHistoryTableView.dataSource = self
        idHistoryTableView.delegate = self
        idHistoryTableView.backgroundColor =  UIColor(red: 0.11, green: 0.16, blue: 0.22, alpha: 1.0)
    }

}

// MARK: - Helper Functions
extension LoginViewController {
    private func checkTextField(textField: UITextField) -> Bool {
        return !(textField.text == nil || textField.text == "")
    }
    
    private func isValidSteamID32(_ steamID: String) -> Bool {
        let steamIDCharacterSet = CharacterSet.decimalDigits
        let steamIDLength = steamID.count
        
        return steamIDLength >= 7 && steamID.allSatisfy({ steamIDCharacterSet.contains($0.unicodeScalars.first!) })
    }
    
    private func showAlertForInvalidSteamID() {
        let alertController = UIAlertController(title: "Некорректный SteamID32", message: "Пожалуйста, введите действительный SteamID32.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        steamIDTextField.text = ""
    }
}

// MARK: - Navigation
extension LoginViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let profileVC = segue.destination as? ProfileViewController, let steamID = sender as? String else { return }
        profileVC.steamID = steamID
    }
}

// MARK: - Core Data
extension LoginViewController {
    private func saveSteamIDIfNotExists(steamID: String) {
        guard !savedSteamIDs.contains(where: { ($0.value(forKey: "steamID") as? String) == steamID }) else { return }

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SteamID", in: managedContext)!
        let newSteamID = NSManagedObject(entity: entity, insertInto: managedContext)

        newSteamID.setValue(steamID, forKey: "steamID")

        do {
            try managedContext.save()
            savedSteamIDs.append(newSteamID)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func loadSavedSteamIDs() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SteamID")
        
        do {
            savedSteamIDs.removeAll()
            savedSteamIDs = try managedContext.fetch(fetchRequest)
            idHistoryTableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension LoginViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedSteamIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "steamIDCell", for: indexPath)
        let steamID = savedSteamIDs[indexPath.row]
        cell.textLabel?.text = steamID.value(forKey: "steamID") as? String
        cell.backgroundColor = UIColor(red: 0.11, green: 0.16, blue: 0.22, alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let steamID = savedSteamIDs[indexPath.row]
        if let selectedSteamID = steamID.value(forKey: "steamID") as? String {
            performSegue(withIdentifier: "profileSegue", sender: selectedSteamID)
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
