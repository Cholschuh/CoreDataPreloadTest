//
//  ViewController.swift
//  CoreDataPreloadTest
//
//  Created by Chris Holschuh on 1/29/20.
//  Copyright © 2020 Chris Holschuh. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class ViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureFetchedResultsController()
        tblView.dataSource = self
        if coreDataHelper.recordVistedLoc(name: "Test"){
            print("Record Saved")
        } else{
            print("error")
        }
        
    }
    @IBAction func preHeavyBtn(_ sender: UIButton) {
        //Haptic feedback UIImpact medium
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
        
    }
    @IBAction func preLightBtn(_ sender: UIButton) {
        //Haptic feedback UIImpact medium
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
    }
    @IBAction func preRigidBtn(_ sender: UIButton) {
        //Haptic feedback UIImpact medium
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.prepare()
        generator.impactOccurred()
        
    }
    @IBAction func composerBtn(_ sender: UIButton) {
        showMailComposer()
    }
    @IBAction func preMediumBtn(_ sender: UIButton) {
        
        //Haptic feedback UIImpact medium
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        
    }
    @IBAction func nSuccessBtn(_ sender: UIButton) {
        //Haptic feedback Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    @IBAction func nErrorBtn(_ sender: UIButton) {
        //Haptic feedback Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    @IBAction func nWarningBtn(_ sender: UIButton) {
        //Haptic feedback Success
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    @IBAction func ClearVisited(_ sender: UIButton) {
        if coreDataHelper.clearAllVistedLoc(){
            print("Visted Locations Cleared")
            
            //Haptic feedback Success
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }else{
            print("Error")
        }
    }
    func showMailComposer(){
        guard MFMailComposeViewController.canSendMail() else {
            print("Email is not supported on this device")
            return
        }
        let composer =  MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["Chris.csrstaff@gmail.com"])
        composer.setSubject("This is a Email from the app you coded")
        composer.setMessageBody("It works! See See ", isHTML: false)
        present(composer, animated: true)
    }
    private func configureFetchedResultsController(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RoomMO")
        let sortDescripter = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
        
        do{
            try fetchedResultsController?.performFetch()
        }catch {
            print(error.localizedDescription)
        }
    }
    
}
extension ViewController: NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Data has changed")
        tblView.reloadData()
    }
}
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else {
            return 0
        }
        let rowsCount = sections[section].numberOfObjects
        //print(rowsCount)
        return rowsCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let room = fetchedResultsController?.object(at: indexPath) as? RoomMO{
            cell.textLabel?.text = room.name
            
        }
        return cell
    }
}
extension ViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            controller.dismiss(animated: true, completion: nil)
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
            case .sent:
            print("Sent!")
        default:
            print("Not accounted for")
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
}
