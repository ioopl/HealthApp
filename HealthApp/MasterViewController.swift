//
//  MasterViewController.swift
//  HealthApp
//
//  Created by UHS on 23/12/2017.
//  Copyright © 2017 Apkia. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, MessagesTableViewCellDelegate {
    
    // MARK: - MessagesTableViewCellDelegate Method
    func messagesTableViewCellDeleteDidTapped(_ messageTableViewCell: MessagesTableViewCell) {
        guard let indexPath = messageTableViewCell.indexPathForCell else { return }
        deleteButtonDidPress(indexPath: indexPath)
    }
    
    // MARK: - Vaiables
    var detailViewController: DetailViewController? = nil
    var messageResponse = [MessageResponse]()
    var appointmentResponse = [AppointmentResponse]()
    let url: URL = URL.init(string: "http://www.iplato.net/test/ios-test.php")!
    
    // MARK: - Enums/Data Structures
    enum TableSection: String {
        case Messages = "Message Inbox"
        case Appointments = "My Appointments"
    }
    
    // MARK: - Properties
    var tableSections: [TableSection] = [.Messages, .Appointments]

    // MARK: - View Controller Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        getJsonFromUrl(url: url)
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let displayTableSection = tableSections[section]
        if displayTableSection == .Messages {
            return messageResponse.count
        } else {
            return appointmentResponse.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableSection = tableSections[indexPath.section]
        if tableSection == .Messages {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessagesTableViewCell
            let object = messageResponse[indexPath.row].sender_name
            cell.labelName.text = object.description
            cell.labelMessage.text = messageResponse[indexPath.row].body
            cell.delegate = self
            cell.indexPathForCell = indexPath
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppointmentsTableViewCell
            let object = appointmentResponse[indexPath.row].doctor_name
            cell.labelName.text = object.description
            cell.labelDate.text = appointmentResponse[indexPath.row].start_at
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Display Title for individual sections.
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let tableSection = tableSections[section]
        return tableSection.rawValue
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //Centrally align table view sections
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .center
        }
    }
    
    // Delete item from the messages object @ indexPath
    private func deleteButtonDidPress(indexPath: IndexPath) {
        messageResponse.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    // MARK: -  API Call
    
    //this function is fetching the json from URL
    func getJsonFromUrl(url: URL){
        //creating a NSURL
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url), completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                // [ Dictionary --- { Array
                // getting the messages tag array from json and converting it to NSArray
                if let messagesArray = jsonObj!.value(forKey: "messages") as? [[String: Any]] {
                    // looping through all the elements
                    for message in messagesArray {
                        let response = MessageResponse(dictionary: [message])
                        self.messageResponse.append(response)
                        // Sort array of message object by property value "sender_name"
                        self.messageResponse.sort(by: {$0.sender_name < $1.sender_name})
                    }
                }
                //getting the appointments tag array from json and converting it to NSArray
                if let messagesArray = jsonObj!.value(forKey: "appointments") as? [[String: Any]] {
                    // looping through all the elements
                    for message in messagesArray {
                        let response = AppointmentResponse(dictionary: [message])
                        self.appointmentResponse.append(response)
                    }
                }
                // Back to main Queue
                OperationQueue.main.addOperation({
                    //calling function after fetching the json
                    self.tableView.reloadData()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                })
            }
        }).resume()
    }
}

