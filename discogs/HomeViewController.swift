//
//  HomeViewController.swift
//  discogs
//
//  Created by John Yam on 2/20/18.
//

import UIKit
import OAuthSwift

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        ServiceClient.sharedInstance.authorize(resource: User.authenticatedUser, viewController: self) { (user) in
            print("test: \(user)")

        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
  

}
