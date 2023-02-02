//
//  ViewController.swift
//  healthkit-test
//
//  Created by 박경준 on 2023/01/31.
//

import UIKit
import HealthKit
class ViewController: UIViewController {
    
    let healthStore = HKHealthStore()
    
    let read = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!, HKObjectType.quantityType(forIdentifier: .stepCount)!, HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!, HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!])
    let share = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!, HKObjectType.quantityType(forIdentifier: .stepCount)!, HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!, HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)!])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        requestAuthorization()
    }
    
    func requestAuthorization(){
        healthStore.requestAuthorization(toShare: share, read: read) { success, error in
            if (error != nil){
                print(error?.localizedDescription)
            }else{
                if(success){
                    print("권한이 허용되었어요.")
                }else{
                    print("권한이 허용되지않았어요.")
                }
            }
        }
    }
    
    func getHeartRate(completion: @escaping ([HKSample]) -> Void){
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        
        let startDate = Calendar.current.date(byAdding: .hour, value: -1, to: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (sample, result, error) in
            
            guard error != nil else{
                print(error?.localizedDescription)
                return
            }
            
            guard let resultData = result else{
                print("load error")
                return
            }
            
            DispatchQueue.main.async {
                completion(resultData)
            }
        }
        
        healthStore.execute(query)
    }


}

