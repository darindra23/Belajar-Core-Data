//
//  ViewController.swift
//  CoreDataManagement
//
//  Created by Darindra R on 22/04/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }

    func reset() {
        updateButton.isEnabled = false
        deleteButton.isEnabled = false
        textField.text = ""
    }

    func enableButton() {
        updateButton.isEnabled = true
        deleteButton.isEnabled = true
    }

    @IBAction func addUser(_ sender: Any) {
        guard let text = textField.text else { return }
        saveUser(name: text)
        reset()
    }

    @IBAction func buttonFetch(_ sender: Any) {
        let user = fetchUser()
        label.text = user
    }

    @IBAction func updateUser(_ sender: Any) {
        guard let selectedUser = self.user else { return }
        guard let text = textField.text else { return }

        updateUser(selectedUser, newName: text)
        reset()
    }

    @IBAction func deleteUser(_ sender: Any) {
        guard let selectedUser = self.user else { return }

        delete(selectedUser)
    }

    func saveUser(name: String) {
        let context = appDelegate.persistentContainer.viewContext
        guard let userEntity = NSEntityDescription.entity(forEntityName: "User", in: context) else { return }
        let user = NSManagedObject(entity: userEntity, insertInto: context)

        user.setValue(name, forKey: "name")

        do {
            try context.save()
        } catch {
            print("Error \(error.localizedDescription)")
        }
    }

    func updateUser(_ user: User, newName: String) {
        let context = appDelegate.persistentContainer.viewContext
        user.setValue(newName, forKey: "name")

        do {
            try context.save()
        } catch {
            print("Error \(error.localizedDescription)")
        }

    }

    func delete(_ user: User) {
        let context = appDelegate.persistentContainer.viewContext
        context.delete(user)

        do {
            try context.save()
        } catch {
            print("Error \(error.localizedDescription)")
        }
    }

    func fetchUser() -> String? {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")

        var users = [NSManagedObject]()

        do {
            users = try context.fetch(fetchRequest)
        } catch {
            print("Error \(error.localizedDescription)")
            return nil
        }

        guard let user = users as? [User] else { return "" }
        countLabel.text = "Data Count : \(user.count)"

        if !user.isEmpty {
            self.user = user[0]

            enableButton()

            return user[0].name
        }

        reset()
        return "No Data Exist"
    }
}
