//
//  ViewController.swift
//  HealthKit-Test
//
//  Created by Nathanael Hartanto on 3/5/23.
//

import UIKit
import HealthKit

@available(iOS 14.0, *)
class ViewController: UIViewController {

    
    let healthStore = HKHealthStore()
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit()
        // Do any additional setup after loading the view.
    }
    func authorizeHealthKit(){
        let read = Set([HKObjectType.quantityType(forIdentifier: .walkingStepLength)!])
        let share = Set([HKObjectType.quantityType(forIdentifier: .walkingStepLength)!])
        healthStore.requestAuthorization(toShare: share, read: read) { chk, err in
            if(chk){
                print("permission granted")
                self.latestWalkingStepLength()
            }
        }
    }
    
    func latestWalkingStepLength(){
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .walkingStepLength) else{
            return
        }
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            guard error == nil else{
                return
            }
            
        }
        healthStore.execute(query)
    }

}

