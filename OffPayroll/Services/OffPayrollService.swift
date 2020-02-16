//
//  OffPayrollService.swift
//  OffPayroll
//
//  Created by Jon Preece on 15/02/2020.
//  Copyright © 2020 Jon Preece. All rights reserved.
//

import CoreData
import UIKit
import Alamofire

class OffPayrollService {
    typealias APIRequestCompletion = () -> Void
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext
    var fetchRequest: NSFetchRequest<Likes>
    var controller: NSFetchedResultsController<Likes>
    
    init() {
        context = appDelegate.persistentContainer.viewContext
        fetchRequest = Likes.fetchRequest()
        
        let defaultSort = NSSortDescriptor(key: "contractId", ascending: false)
        fetchRequest.sortDescriptors = [defaultSort]
        
        controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func likeContract(contractId: Int32) -> Void {
        let like = Likes(context: context)
        like.contractId = contractId
        
        postToServer(contractId: contractId) {
            self.appDelegate.saveContext()
        }
    }
    
    func hasPreviouslyLiked(contractId: Int32) -> Bool {
        do {
            try controller.performFetch()
            let likes = controller.fetchedObjects!
            return likes.contains { (like) -> Bool in
                return like.contractId == contractId
            }
        } catch {
            let error = error as NSError
            print(error)
            return false
        }
    }
    
    func flagAProblem(contractId: Int32, reason: String, furtherDetails: String?, onComplete: @escaping APIRequestCompletion) {
        let url = URL(string: "https://jobs-api.offpayroll.org.uk/api/jobs/feedback")!
        let body: Dictionary<String,Any> = ["feedback": reason, "feedbackDetails": furtherDetails ?? "", "jobId": contractId]
        
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                onComplete()
        }
    }
    
    private func postToServer(contractId: Int32, onComplete: @escaping APIRequestCompletion) {
        let url = URL(string: "https://jobs-api.offpayroll.org.uk/api/jobs/feedback")!
        let body: Dictionary<String,Any> = ["feedback": "like", "feedbackDetails": "", "jobId": contractId]
        
        Alamofire.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                onComplete()
        }
    }
}
