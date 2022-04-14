//
//  AddElementView.swift
//  Sport
//
//  Created by Андрей Гаврилов on 11.04.2022.
//

import UIKit
import Foundation
import Firebase

final class AddElementViewController: UIViewController, UITextFieldDelegate {

    // MARK: - IBOutlets
    private var nameTextField: UITextField!
    private var placeTextField: UITextField!
    private var timeTextField: UITextField!
    private var switchButton: UISwitch!
    private var firebaseLabel: UILabel!
    private var dataCoreLabel: UILabel!
    private var saveButton: UIButton!
    private var modelsCoreData = [SportEntity]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Private Properties
    // array of constraints for "wide" layout
    private var wideConstraints: [NSLayoutConstraint] = []
    // array of constraints for "narrow" layout
    private var narrowConstraints: [NSLayoutConstraint] = []
    // just for clarity, array of constraints that apply for
    //  both wide and narrow layouts
    private var commonConstraints: [NSLayoutConstraint] = []
    private var ref: DatabaseReference!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        installOutlets()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            if size.width > size.height {
                // we're transitioning to wider than tall
                NSLayoutConstraint.deactivate(self.narrowConstraints)
                NSLayoutConstraint.activate(self.wideConstraints)
            } else {
                // we're transitioning to taller than wide
                NSLayoutConstraint.deactivate(self.wideConstraints)
                NSLayoutConstraint.activate(self.narrowConstraints)
            }
        }, completion: {
            _ in
            // if you want to do somwthing after the transition, do this here
        })
    }
    
    // MARK: - Private Methods
    @objc private func saveButtonDidtaped() {
        if !(nameTextField.text!.isEmpty || placeTextField.text!.isEmpty || timeTextField.text!.isEmpty) {
            if switchButton.isOn {
                createItemFirebase()
            } else {
                createItemCoreData()
            }
        } else {
            let alert = UIAlertController(title: "No data", message: "Fields are empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
        }
    }
    
    private func createItemFirebase() {
        self.ref = Database.database().reference()
        self.ref.child("LSbJXig4YbOP6ET9wbCekBFeOJd2")/*.child(randomString(length: 4))*/.setValue(["name": self.nameTextField.text!, "place": self.placeTextField.text!, "time": self.timeTextField.text!, "isDataFromFirebase": "Yes"]) {
                (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }

    }
    
    private func createItemCoreData() {
        let newItem = SportEntity(context: context)
        newItem.name = self.nameTextField.text!
        newItem.place = self.placeTextField.text!
        newItem.time = self.timeTextField.text!
        newItem.isDataFromFirebase = "No"
        
        do {
            try context.save()
        }
        catch let error {
            print(error)
        }
    }

    
    private func installOutlets() {
        title = "Add"
        view.backgroundColor = .white
        
        nameTextField = UITextField()
        nameTextField.borderStyle = .none
        nameTextField.layer.backgroundColor = UIColor.white.cgColor
        nameTextField.layer.masksToBounds = false
        nameTextField.layer.shadowColor = UIColor.gray.cgColor
        nameTextField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        nameTextField.layer.shadowOpacity = 1.0
        nameTextField.layer.shadowRadius = 0.0
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "Name"
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name", attributes:[NSAttributedString.Key.foregroundColor: UIColor.black])
        nameTextField.autocapitalizationType = .none
        nameTextField.textAlignment = .center
        view.addSubview(nameTextField)
        
        placeTextField = UITextField()
        placeTextField.borderStyle = .none
        placeTextField.layer.backgroundColor = UIColor.white.cgColor
        placeTextField.layer.masksToBounds = false
        placeTextField.layer.shadowColor = UIColor.gray.cgColor
        placeTextField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        placeTextField.layer.shadowOpacity = 1.0
        placeTextField.layer.shadowRadius = 0.0
        placeTextField.translatesAutoresizingMaskIntoConstraints = false
        placeTextField.placeholder = "Place"
        placeTextField.attributedPlaceholder = NSAttributedString(string: "Place", attributes:[NSAttributedString.Key.foregroundColor: UIColor.black])
        placeTextField.autocapitalizationType = .none
        placeTextField.textAlignment = .center
        view.addSubview(placeTextField)
        
        timeTextField = UITextField()
        timeTextField.borderStyle = .none
        timeTextField.layer.backgroundColor = UIColor.white.cgColor
        timeTextField.layer.masksToBounds = false
        timeTextField.layer.shadowColor = UIColor.gray.cgColor
        timeTextField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        timeTextField.layer.shadowOpacity = 1.0
        timeTextField.layer.shadowRadius = 0.0
        timeTextField.translatesAutoresizingMaskIntoConstraints = false
        timeTextField.placeholder = "00:00"
        timeTextField.attributedPlaceholder = NSAttributedString(string: "00:00", attributes:[NSAttributedString.Key.foregroundColor: UIColor.black])
        timeTextField.autocapitalizationType = .none
        timeTextField.textAlignment = .center
        view.addSubview(timeTextField)
        
        switchButton = UISwitch()
        switchButton.backgroundColor = .systemGreen
        switchButton.layer.cornerRadius = 15
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(switchButton)
        
        firebaseLabel = UILabel()
        firebaseLabel.text = "Firebase"
        firebaseLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firebaseLabel)
        
        dataCoreLabel = UILabel()
        dataCoreLabel.text = "Data core"
        dataCoreLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dataCoreLabel)
        
        saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.alpha = 1
        
        /*
            I'm not a designer and so I couldn't decide on the best way to make this button look. With orwithout a small border
            */
//        saveButton.layer.borderWidth = 1
//        saveButton.layer.borderColor = .init(red: 200, green: 200, blue: 200, alpha: 1)
        
        saveButton.layer.cornerRadius = 5
        saveButton.setTitleColor(.gray, for: .highlighted)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = .black
        saveButton.addTarget(self, action: #selector(saveButtonDidtaped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.clipsToBounds = true
        view.addSubview(saveButton)
        
//        let safeArea = view.safeAreaLayoutGuide
        let screenWidth = UIScreen.main.bounds.height
        let space = screenWidth/2
//        commonConstraints = [
//            nameTextField.topAnchor.constraint(equalTo: view.topAnchor,constant: space/2.5),
//            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: space/6.5),
//            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -space/6.5),
//            placeTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 30),
//            placeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: space/6.5),
//            placeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -space/6.5),
//            timeTextField.topAnchor.constraint(equalTo: placeTextField.bottomAnchor, constant: 30),
//            timeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: space/6.5),
//            timeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -space/6.5)
//        ]
        
        narrowConstraints = [
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: space/2.5),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: space/6.5),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -space/6.5),
            
            placeTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 50),
            placeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: space/6.5),
            placeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -space/6.5),
            
            timeTextField.topAnchor.constraint(equalTo: placeTextField.bottomAnchor, constant: 50),
            timeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: space/6.5),
            timeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -space/6.5),
            
            switchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            switchButton.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: 50),

            dataCoreLabel.centerYAnchor.constraint(equalTo: switchButton.centerYAnchor),
            dataCoreLabel.trailingAnchor.constraint(equalTo: switchButton.leadingAnchor, constant: -10),

            firebaseLabel.centerYAnchor.constraint(equalTo: switchButton.centerYAnchor),
            firebaseLabel.leadingAnchor.constraint(equalTo: switchButton.trailingAnchor, constant: 10),
            
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: switchButton.bottomAnchor, constant: 50),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:UIScreen.main.bounds.width/3.5),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-UIScreen.main.bounds.width/3.5),
        ]
        wideConstraints = [
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: space/4.5),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: space/6.5),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -space/6.5),
            
            placeTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 30),
            placeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: space/6.5),
            placeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -space/6.5),
            
            timeTextField.topAnchor.constraint(equalTo: placeTextField.bottomAnchor, constant: 30),
            timeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: space/6.5),
            timeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -space/6.5),
            
            switchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            switchButton.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: 30),
            
            dataCoreLabel.centerYAnchor.constraint(equalTo: switchButton.centerYAnchor),
            dataCoreLabel.trailingAnchor.constraint(equalTo: switchButton.leadingAnchor, constant: -20),

            firebaseLabel.centerYAnchor.constraint(equalTo: switchButton.centerYAnchor),
            firebaseLabel.leadingAnchor.constraint(equalTo: switchButton.trailingAnchor, constant: 20),
            
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: switchButton.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:UIScreen.main.bounds.width/2.5),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:-UIScreen.main.bounds.width/2.5),
        ]
        
        // check the commonConstraints
//        NSLayoutConstraint.activate(commonConstraints)
        if view.frame.width > view.frame.height {
            // wider than tall -> "wide"
            NSLayoutConstraint.activate(wideConstraints)
        } else {
            // taller than wide -> "narrow"
            NSLayoutConstraint.activate(narrowConstraints)
        }
    }
        
    private func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }

}
