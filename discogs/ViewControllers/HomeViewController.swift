//
//  HomeViewController.swift
//  discogs
//
//  Created by John Yam on 2/20/18.
//

import UIKit


class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DiscogsClient.shared.setCredentialsFromKeychain { (success) in
            if success {
                self.getUser()
            } else {
                self.authorize()
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    private func authorize() {
        let queue = OperationQueue()
        let operation = BlockOperation(block: {
            DiscogsClient.shared.authorize(with: self)
        })
        operation.completionBlock = getUser
        queue.addOperation(operation)
    }
    
    private func getUser() {
        DiscogsClient.shared.getUserIdentity(resource: User.authenticatedUser, completion: { result in
            switch result {
            case .success(let user):
                user.save()
            case .error(let e):
                print("problem with getting identity \(e)")
            }
        })
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
  

}
