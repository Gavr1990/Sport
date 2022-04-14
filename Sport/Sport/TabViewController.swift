//
//  TabViewController.swift
//  Sport
//
//  Created by Андрей Гаврилов on 11.04.2022.
//

import UIKit
import Foundation

final class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let addElementViewController = AddElementViewController()
        let resultsViewController = ResultsViewController()
        self.setViewControllers([addElementViewController, resultsViewController], animated: true)
        self.modalPresentationStyle = .fullScreen
//        self.tabBar.barTintColor = .black
        self.tabBar.items?[0].image = UIImage(systemName: "plus")
        self.tabBar.items?[1].image = UIImage(systemName: "table")
        // Do any additional setup after loading the view.
    }


}
