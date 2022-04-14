//
//  ResultsViewController.swift
//  Sport
//
//  Created by Андрей Гаврилов on 11.04.2022.
//

import UIKit
import Foundation
import Firebase

final class ResultsViewController: UIViewController {
    
    // MARK: - IBOutlets
    private var tableOfAchivments: UITableView!
    private var buttonOfChangingTable: UIButton!
    
    // MARK: - Private Properties
    private let identifire = "MyCell"
    private var wideConstraints: [NSLayoutConstraint] = []
    private var narrowConstraints: [NSLayoutConstraint] = []
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var modelsFirebase = [Sport]()
    private var modelsCoreData = [SportEntity]()
    private var counter = 0
    private let titleArray = ["All", "Core Data", "Firebase"]
    private let colorArray = [UIColor.black, UIColor.systemGreen, UIColor.systemRed]
    private var ref: DatabaseReference!
    
    private lazy var labelHeaderName: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "Roboto-Medium", size: 12)
        label.textAlignment = .center
        label.text = "Name"
        label.backgroundColor = .white
        return label
    }()

    private lazy var labelHeaderPlace: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "Roboto-Medium", size: 12)
        label.textAlignment = .center
        label.text = "Place"
        label.backgroundColor = .white
        return label
    }()
    
    private lazy var labelHeaderTime: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(name: "Roboto-Medium", size: 12)
        label.textAlignment = .center
        label.text = "Time"
        label.backgroundColor = .white
        return label
    }()
    // MARK: - Initializers
//    init(emailUser: String, data: Company) {
//        super.init(nibName: nil, bundle: nil)
//        self.data = data
//        typeOfShowVC = false
//        for i in 0...data.users.count - 1 {
//            if data.users[i].info.email == emailUser {
//                labelQuantityHoursWeek.text = "\(data.users[i].work.weekHours!)"
//                labelQuantityAllOfHours.text = "\(data.users[i].work.totalHours!)"
//                labelQuantityHoursMonth.text = "\(data.users[i].work.monthHours!)"
//                labelOfProfileButton.text = "\(data.users[i].info.name!) \(data.users[i].info.surname!)"
//                myId = i
//                countOfDays = data.users[i].days.count
//            }
//        }
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
    
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
                NSLayoutConstraint.deactivate(self.narrowConstraints)
                NSLayoutConstraint.activate(self.wideConstraints)
            } else {
                NSLayoutConstraint.deactivate(self.wideConstraints)
                NSLayoutConstraint.activate(self.narrowConstraints)
            }
        }, completion: {
            _ in
            // if you want to do somwthing after the transition, do this here
        })
    }
    
    override func viewDidLayoutSubviews() {
        getAllItems()
    }
    
    // MARK: - Private Methods
    private func installOutlets() {
        view.backgroundColor = .white
        title = "Table"
        
        buttonOfChangingTable = UIButton()
        buttonOfChangingTable.setTitle("All", for: .normal)
        buttonOfChangingTable.layer.cornerRadius = 5
        buttonOfChangingTable.layer.borderWidth = 1
        buttonOfChangingTable.layer.borderColor = .init(red: 200, green: 200, blue: 200, alpha: 1)
        buttonOfChangingTable.setTitleColor(.gray, for: .highlighted)
        buttonOfChangingTable.setTitleColor(.black, for: .normal)
        buttonOfChangingTable.backgroundColor = .none
        buttonOfChangingTable.addTarget(self, action: #selector(buttonDidtaped), for: .touchUpInside)
        buttonOfChangingTable.translatesAutoresizingMaskIntoConstraints = false
        buttonOfChangingTable.clipsToBounds = true
        view.addSubview(buttonOfChangingTable)

        
        tableOfAchivments = UITableView()
        tableOfAchivments.translatesAutoresizingMaskIntoConstraints = false
        tableOfAchivments.delegate = self
        tableOfAchivments.dataSource = self
        tableOfAchivments.register(UITableViewCell.self, forCellReuseIdentifier: identifire)
        tableOfAchivments.separatorStyle = .none
        view.addSubview(tableOfAchivments)
        
        narrowConstraints = [
            buttonOfChangingTable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonOfChangingTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableOfAchivments.topAnchor.constraint(equalTo: buttonOfChangingTable.bottomAnchor),
            tableOfAchivments.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableOfAchivments.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableOfAchivments.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]
        wideConstraints = [
            buttonOfChangingTable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonOfChangingTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableOfAchivments.topAnchor.constraint(equalTo: buttonOfChangingTable.bottomAnchor),
            tableOfAchivments.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableOfAchivments.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableOfAchivments.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ]
        
        if view.frame.width > view.frame.height {
            NSLayoutConstraint.activate(wideConstraints)
        } else {
            NSLayoutConstraint.activate(narrowConstraints)
        }

    }
    
    private func getAllItems() {
        do {
            modelsCoreData = try context.fetch(SportEntity.fetchRequest())
            getDataFirebase()
            DispatchQueue.main.async {
                self.tableOfAchivments.reloadData()
            }
        }
        catch let error {
            print(error)
        }
    }
    
    private func getDataFirebase() {
        ref = Database.database().reference()

        self.ref.getData(completion:  { [weak self] error, snapshot in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard
                let self = self,
                var json = snapshot.value as? [String: Any]
            else {
                return
            }
//            json["LSbJXig4YbOP6ET9wbCekBFeOJd2"] = snapshot.key
            json["isDataFromFirebase"] = snapshot.key
            json["name"] = snapshot.key
            json["place"] = snapshot.key
            json["time"] = snapshot.key
                        
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                let groceryItem = try JSONDecoder().decode(Sport.self, from: jsonData)
                self.modelsFirebase.append(groceryItem)
//                print(groceryItem)
            } catch let error {
              print("an error occurred", error)
            }

        })

    }

    
    @objc func buttonDidtaped() {
        counter = (counter + 1) % titleArray.count
        buttonOfChangingTable.setTitle(titleArray[counter], for: .normal)
        buttonOfChangingTable.setTitleColor(colorArray[counter], for: .normal)
        tableOfAchivments.reloadData()
    }

}

extension ResultsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let stackViewHeader = UIStackView(arrangedSubviews: [labelHeaderName, labelHeaderPlace, labelHeaderTime])
        stackViewHeader.axis = .horizontal
        stackViewHeader.alignment = .center
        stackViewHeader.distribution = .fillEqually
        
        let constraintsOfLabel: [NSLayoutConstraint] = [
            labelHeaderName.topAnchor.constraint(equalTo: stackViewHeader.topAnchor),
            labelHeaderPlace.topAnchor.constraint(equalTo: stackViewHeader.topAnchor),
            labelHeaderTime.topAnchor.constraint(equalTo: stackViewHeader.topAnchor),
        ]
        NSLayoutConstraint.deactivate(constraintsOfLabel)
        NSLayoutConstraint.activate(constraintsOfLabel)
        
        return stackViewHeader
    }
}

extension ResultsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return modelsCoreData.count
        // MARK: Add Firebase
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        var cell = TableViewCell(style: .default, reuseIdentifier: "MyCell", indexPath: indexPath, accessoryType: .none, name: "", place: "", time: "")
        switch counter {
        case 0:
            let model = modelsCoreData[indexPath.row]
            cell = TableViewCell(style: .default, reuseIdentifier: "MyCell", indexPath: indexPath, accessoryType: .none, name: model.name ?? "", place: model.place ?? "", time: model.time ?? "")
        case 1:
            let model = modelsCoreData[indexPath.row]
            cell = TableViewCell(style: .default, reuseIdentifier: "MyCell", indexPath: indexPath, accessoryType: .none, name: model.name ?? "", place: model.place ?? "", time: model.time ?? "")
        case 2:
            let model = modelsFirebase[indexPath.row]
            cell = TableViewCell(style: .default, reuseIdentifier: "MyCell", indexPath: indexPath, accessoryType: .none, name: model.name, place: model.place, time: model.time)
        default:
            print("How it posible?")
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
//
//        return cell
//    }

    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    // Override to support rearranging the table view.
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    
}
