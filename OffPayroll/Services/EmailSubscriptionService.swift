//
//  EmailSubscriptionService.swift
//  OffPayroll
//
//  Created by Jon Preece on 16/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import CoreData
import UIKit
import Alamofire

class EmailSubscriptionService {
    typealias APIRequestCompletion = () -> Void
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext
    var fetchRequest: NSFetchRequest<Subscriptions>
    var controller: NSFetchedResultsController<Subscriptions>
    
    init() {
        context = appDelegate.persistentContainer.viewContext
        fetchRequest = Subscriptions.fetchRequest()
        
        let defaultSort = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [defaultSort]
        
        controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func hasSubscribed() -> Bool {
        do {
            try controller.performFetch()
            let likes = controller.fetchedObjects!
            return likes.count > 0
        } catch {
            let error = error as NSError
            print(error)
            return false
        }
    }
    
    func subscribe(emailAddress: String, onComplete: @escaping APIRequestCompletion) -> Void {
        
        let url = URL(string: "https://jobs-api.offpayroll.org.uk/api/EmailSubscriptions?emailAddress=\(emailAddress)")!
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                let result = response.result
                if let dict = result.value as? Dictionary<String, AnyObject> {
                    
                    let subscription = Subscriptions(context: self.context)
                    subscription.id = dict["id"] as? UUID
                    subscription.emailAddress = dict["emailAddress"] as? String
                    subscription.accessToken = dict["accessToken"] as? String
                    subscription.isSubscribedToGlobalEmail = dict["isSubscribedToGlobalEmail"] as! Bool
                    
                    self.appDelegate.saveContext()
                }
                
                onComplete()
        }
    }
    
    func unsubscribe(emailAddress: String, onComplete: @escaping APIRequestCompletion) -> Void {
        
        let url = URL(string: "https://jobs-api.offpayroll.org.uk/api/EmailSubscriptions/unsubscribe/\(emailAddress)")!
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                do {
                    try self.controller.performFetch()
                    let subscriptions = self.controller.fetchedObjects!
                    
                    for subscription in subscriptions {
                        self.context.delete(subscription)
                    }
                    
                    self.appDelegate.saveContext()
                    
                } catch {
                    let error = error as NSError
                    print(error)
                }
                
                onComplete()
        }
    }
}
