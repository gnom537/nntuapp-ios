//
//  MoreLineNavigationController.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 28.07.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import UIKit

class MoreLineNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self.viewControllers.first {
            self.setNavigationBarHidden(true, animated: animated)
        } else {
            self.setNavigationBarHidden(false, animated: animated)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
