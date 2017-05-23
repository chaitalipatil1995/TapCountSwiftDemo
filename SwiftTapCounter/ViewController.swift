//
//  ViewController.swift
//  SwiftTapCounter
//
//  Created by Amesten Systems on 15/05/17.
//  Copyright © 2017 Amesten Systems. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    
    var seconds = 3600
    var i: Int = 0
    var checkFlag :Int = 0
    var timer: Timer?
    var limit : Int = 108
    var menuFlag :Int = 1
    var clockTimer = Timer()

    @IBOutlet var tapMeTitleLabel: UILabel!
    
    var audioPlayer: AVAudioPlayer!
    
    
    var taps : [NSManagedObject] = []

    var menuArray: NSMutableArray = ["Add new limit", "Default", "Start without tap","StopWatch","Exit"]
    @IBOutlet var menuTableView: UITableView!
    @IBOutlet var okOutlet: UIButton!
    @IBOutlet var resetOutlet: UIButton!
    
    @IBOutlet var tapButton: UIButton!
    @IBAction func TapAction(_ sender: AnyObject) {
        
        menuTableView.isHidden = true
        menuFlag = 1
        
        if(i < limit){
            i = i+1
            numberOfTapsAction.text = String(i)
        } else {
            
            let path = Bundle.main.path(forResource: "klasik_iphone", ofType: "mp3")
            let fileURL = NSURL(fileURLWithPath: path!)
            do {
                try audioPlayer =  AVAudioPlayer(contentsOf: fileURL as URL)
            } catch {
                print("error")
            }
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            self.showAlertForFinishing()
            
            i = 0
        }
        
    }
    @IBOutlet var numberOfTapsAction: UILabel!
    
    @IBAction func resetAction(_ sender: AnyObject) {
        seconds = 3600
        minuteLabel.text = "00:00:00"
        i = 0
        numberOfTapsAction.text = String(i)
    }
    
    @IBAction func oKAction(_ sender: AnyObject) {
        self.stopTimer()
        let textString = self.numberOfTapsAction.text
        
        self.saveAction(number: textString!)
        let secondView = self.storyboard?.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        self.navigationController?.pushViewController(secondView, animated: true)
        tapMeTitleLabel.isHidden = true

    }
    
    func saveAction(number: String) {
        
        let s1 = number
        let s2 = "0"
        
        if s1 == s2 {
            self.showAlert()
            
            let path = Bundle.main.path(forResource: "klasik_iphone", ofType: "mp3")
            let fileURL = NSURL(fileURLWithPath: path!)
            do {
                try audioPlayer =  AVAudioPlayer(contentsOf: fileURL as URL)
            } catch {
                print("error")
            }
            audioPlayer.prepareToPlay()
            audioPlayer.play()            //alert for empty counter
        } else  {
        
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistanceContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "TAPS", in: managedContext)!
            let tap = NSManagedObject(entity: entity, insertInto: managedContext)
            tap.setValue(number, forKey: "tap")
            do{
                try managedContext.save()
                taps.append(tap)
            } catch let error as NSError {
                print("counld not save. \(error), \(error.userInfo)")
            }
        }
    }
    func showAlert(){
        
        let alertController = UIAlertController(title: "Oops", message: "Counter is empty", preferredStyle: .alert)
        
        //let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let defaultAction = UIAlertAction(title: "Ok", style: .default) { [unowned self] action in
            
            self.audioPlayer.stop()
        }
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    
    }
    func showAlertForFinishing(){
        
        let alertController = UIAlertController(title: "Alert", message: "Counter completed", preferredStyle: .alert)
        
        //let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let defaultAction = UIAlertAction(title: "Ok", style: .default) { [unowned self] action in
            
            self.audioPlayer.stop()
        }
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        navigationController?.navigationBar.barTintColor = UIColor.black
        resetOutlet.layer.borderColor = UIColor.black.cgColor
        resetOutlet.layer.borderWidth = 0.2
        okOutlet.layer.borderColor = UIColor.black.cgColor
        okOutlet.layer.borderWidth = 0.2
        menuTableView.isHidden = true

        stopButton.isHidden = true
        startButton.isHidden = true
        minuteLabel.isHidden = true
        
        upDownSwitch.isHidden = true
        
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    
    @IBAction func menuAction(_ sender: AnyObject) {
        menuTableView.isHidden = false
        menuTableView.reloadData()
        
        if menuFlag == 1 {
            menuTableView.isHidden = false
            menuFlag = 0
            
        } else if menuFlag == 0{
            menuTableView.isHidden = true
            menuFlag = 1
        }
    }
    
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "cell"
        let cell:MenuTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MenuTableViewCell

        cell.textLabel?.text = menuArray[indexPath.row] as? String

        return cell as MenuTableViewCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    
    {
        if indexPath.row == 0{
            stopButton.isHidden = true
            startButton.isHidden = true
            minuteLabel.isHidden = true
            upDownSwitch.isHidden = true
            clockTimer.invalidate()
            let alert = UIAlertController(title: "Taps",
                                         message: "Add a new limit for Taps",
                                         preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
                
                guard let textField = alert.textFields?.first,
                    let nameToSave = textField.text else {
                        return
                }
                
                self.save(range: nameToSave)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .default)
            
            alert.addTextField()
            
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
            menuTableView.isHidden = true
            menuFlag = 1
            numberOfTapsAction.isHidden = false

        } else if indexPath.row == 1 {
            clockTimer.invalidate()

            stopButton.isHidden = true
            startButton.isHidden = true
            minuteLabel.isHidden = true
            upDownSwitch.isHidden = true
            
            checkFlag = 1
            menuTableView.isHidden = true
            menuFlag = 1
            numberOfTapsAction.isHidden = false

        } else if indexPath.row == 2 {
            clockTimer.invalidate()
            stopButton.isHidden = true
            startButton.isHidden = true
            minuteLabel.isHidden = true
            upDownSwitch.isHidden = true
            
            menuTableView.isHidden = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerAction), userInfo: nil, repeats: true)
            menuFlag = 1
            stopButton.isHidden = false
            numberOfTapsAction.isHidden = false
            startButton.isHidden = false

        }  else if indexPath.row == 3 {
            stopButton.isHidden = false
            tapMeTitleLabel.isHidden = true
            minuteLabel.isHidden = false
           // runTimer()
            numberOfTapsAction.isHidden = true
            startButton.isHidden = false
            menuTableView.isHidden = true
            upDownSwitch.isHidden = false

        } else if indexPath.row == 4 {
            exit(0)
        }

    }
    func timerAction() {
        //        i = i+1;
        //        numberOfTapsAction.text = String(i)
        
        if(i < limit){
            i = i+1
            numberOfTapsAction.text = String(i)
        } else {
            timer?.invalidate()
            let path = Bundle.main.path(forResource: "klasik_iphone", ofType: "mp3")
            let fileURL = NSURL(fileURLWithPath: path!)
            do {
                try audioPlayer =  AVAudioPlayer(contentsOf: fileURL as URL)
            } catch {
                print("error")
            }
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            self.showAlertForFinishing()
            
            i = 0
        }

    }
    func stopTimer(){
        timer?.invalidate()
        clockTimer.invalidate()
        i = 0
        numberOfTapsAction.text = String(i)
    }
    func save(range: String)  {
        
        let a:Int? = Int(range)
        
        limit = a!
        
    }
    
    
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var startButton: UIButton!

    @IBAction func stopAction(_ sender: AnyObject) {
        timer?.invalidate()
        clockTimer.invalidate()
    }
    
    @IBAction func startAction(_ sender: AnyObject) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timerAction), userInfo: nil, repeats: true)
        clockTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)

    }
    
    @IBOutlet var hourLabel: UILabel!
    
    @IBOutlet var minuteLabel: UILabel!
    
    @IBOutlet var secLabel: UILabel!
    
    func runTimer() {
        clockTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    func updateTimer(){
        
        if upDownSwitch.isOn {
            if seconds < 1 {
                upDownSwitch.thumbTintColor = UIColor.white

                clockTimer.invalidate()
            } else {
                seconds += 1
                minuteLabel.text = timeString(time: TimeInterval(seconds))
            }
        } else {
            upDownSwitch.thumbTintColor = UIColor.blue
            if seconds < 1 {
                clockTimer.invalidate()
            } else {
                seconds -= 1
                minuteLabel.text = timeString(time: TimeInterval(seconds))
            }
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
    //Switch section
    
    @IBOutlet var upLabel: UILabel!
    @IBOutlet var downLabel: UILabel!
    
    @IBOutlet var upDownSwitch: UISwitch!
    
    @IBAction func upDownSwitchAction(_ sender: AnyObject) {
        clockTimer.invalidate()
        self.runTimer()
        
    }
    
    
    
    
    
}

