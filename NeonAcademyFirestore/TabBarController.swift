//
//  TabBarController.swift
//  NeonAcademyFirestore
//
//  Created by Kerem Caan on 11.08.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
    let tb1 = UINavigationController(rootViewController: LoggedInVC())
    let tb2 = UINavigationController(rootViewController: FeedVC())

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        tb1.tabBarItem.image = UIImage(systemName: "person.fill")
        tb1.title = "Profile"
        tb2.tabBarItem.image = UIImage(systemName: "folder.fill")
        tb2.title = "Feed"
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = .purple
        setViewControllers([tb1, tb2], animated: true)
    }

}
