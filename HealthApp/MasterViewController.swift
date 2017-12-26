//
//  MasterViewController.swift
//  HealthApp
//
//  Created by UHS on 23/12/2017.
//  Copyright © 2017 Apkia. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    let url: URL = URL.init(string: "http://www.iplato.net/test/ios-test.php")!

    // MARK: - Vaiables
    var detailViewController: DetailViewController? = nil
    var messageResponse = [MessageResponse]()
    var appointmentResponse = [AppointmentResponse]()

    
    //A string array to save all the names
    var nameArray = [String]()

    // MARK: - Enums/Data Structures
    enum TableSection: String {
        case Messages
        case Appointments
    }
    
    // MARK : Properties
    var tableSections: [TableSection] = [.Messages, .Appointments]


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        getJsonFromUrl(url: url)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
        //objects.insert("Umair", at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = messageResponse[indexPath.row] as! String
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View Delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageResponse.count
        let displayTableSection = tableSections[section]
        if displayTableSection == .Messages {
            return messageResponse.count
        } else {
            return appointmentResponse.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)

        let object = messageResponse[indexPath.row].sender_name
        cell.textLabel!.text = object.description
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            messageResponse.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

// API Call
    
    //this function is fetching the json from URL
    func getJsonFromUrl(url: URL){
        //creating a NSURL
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url), completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                // [ Dictionary
                // { Array 
                // printing the json in console
                print(jsonObj!.value(forKey: "messages")!)
                
                // getting the messages tag array from json and converting it to NSArray
                if let messagesArray = jsonObj!.value(forKey: "messages") as? [[String: Any]] {
                    // looping through all the elements
                    for message in messagesArray {
                        
                        let response = MessageResponse(dictionary: [message])
                        self.messageResponse.append(response)
                        
                        /*
                        // converting the element to a dictionary
                        if let messageDict = message as? NSDictionary {
                            // getting the name from the dictionary
                            if let name = messageDict.value(forKey: "sender_name") {
                                // adding the name to the array
                                self.objects.append((name as? String)!)
                            }
                        }
                        */
                        
                        
                    }
                }
                //getting the messages tag array from json and converting it to NSArray
                
                // Back to main Queue
                OperationQueue.main.addOperation({
                    //calling another function after fetching the json
                    //it will show the names to label
                    self.tableView.reloadData()
                })
            }
        }).resume()
    }
}

