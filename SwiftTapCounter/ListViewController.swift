//
//  ListViewController.swift
//  SwiftTapCounter
//
//  Created by Amesten Systems on 15/05/17.
//  Copyright © 2017 Amesten Systems. All rights reserved.
//

import UIKit
import CoreData
class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var listTableView: UITableView!
    //let managedContext = AppDelegate.persistanceContainer.viewContext

    let reuseIdentifier = String("cell")
    var colors = ["red", "black", "blue", "brown"]
    var taps : [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistanceContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName : "TAPS")
        
        do{
           
            taps = try managedContext.fetch(fetchRequest)
            
            
        } catch let error as NSError {
            
            print("counld not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //make sure you use the relevant array sizes
        return taps.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        
        let cell: listTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as! listTableViewCell!

        let strCarName = taps[indexPath.row]
        let string1 = strCarName.value(forKey: "tap") as? String
        let string2 = "Number of taps:  "
        
        cell.listLabel.text = string2 + string1!
        
        return cell as listTableViewCell
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = taps[indexPath.row]
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistanceContainer.viewContext
            managedContext.delete(task)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName : "TAPS")

            do {
                taps = try managedContext.fetch(fetchRequest)
            } catch {
                print("Fetching Failed")
            }
        }
        listTableView.reloadData()
    }
    
    @IBAction func refreshAction(_ sender: AnyObject) {
        
        self.deleteAllData()
        listTableView.reloadData()

    }
    
    
    
    func deleteAllData()
    {
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDel.persistanceContainer.viewContext
        

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName : "TAPS")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            try managedContext.execute(deleteRequest)

        } catch  {
            print("deleting Failed")

        }
        listTableView.reloadData()

        /*
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDel.persistanceContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName : "TAPS")
        do {
            
            taps = try managedContext.fetch(fetchRequest)

        } catch {
            print("Fetching Failed")
        }
        
            taps.removeAll(keepingCapacity: false)
            
            listTableView.reloadData()
            
            do {
                 try managedContext.save()
            } catch {
                print("Fetching Failed")
            }*/
        }
        
        
        
        
        /*
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistanceContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName : "TAPS")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \("taps") error : \(error) \(error.userInfo)")
        }
        
        listTableView.reloadData()
 */
        

    }
    
    
    
    
    
    
    
    
    
    
    
    

