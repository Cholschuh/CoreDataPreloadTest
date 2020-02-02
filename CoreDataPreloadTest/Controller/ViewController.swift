//
//  ViewController.swift
//  CoreDataPreloadTest
//
//  Created by Chris Holschuh on 1/29/20.
//  Copyright © 2020 Chris Holschuh. All rights reserved.
//

import UIKit
import CoreData

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
    @IBAction func ClearVisited(_ sender: UIButton) {
        if coreDataHelper.clearAllVistedLoc(){
            print("Visted Locations Cleared")
        }else{
            print("Error")
        }
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
