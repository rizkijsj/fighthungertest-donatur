//
//  LokasiList.swift
//  FightHunger Donatur
//
//  Created by muhammad sutrisno on 19/02/19.
//  Copyright © 2019 FightHunger. All rights reserved.
//

import UIKit
import MapKit

class LokasiList: UIViewController, UITableViewDataSource, UITableViewDelegate, MKLocalSearchCompleterDelegate {
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var regionListResearch = MKCoordinateRegion()
    var selectedRegion:MKCoordinateRegion?
    
    @IBOutlet var tblViewLokasiList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchCompleter.delegate = self
    }

    
//    mklocal
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tblViewLokasiList.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResults.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearch.Request(completion: completion)
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { (response, error) in
            let kordinat = response?.mapItems[0].placemark.coordinate
            print(String(describing: kordinat))
            
            let span = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
            
            
            
            self.regionListResearch = MKCoordinateRegion.init(center: kordinat!, span: span)
            self.selectedRegion = self.regionListResearch
                self.exitToMap()
           
        }
    }
    
    func exitToMap(){
         performSegue(withIdentifier: "toMap", sender: self)
    }

    @IBAction func onDismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    //show keyboard
    func textFieldDidBeginEditing(_ textField: Any) {
        moveKeyboard(textField: tblViewLokasiList, moveDistance: -250, up: true)
    }
    
//    hide keyboard
    func textFieldDidEndEditing(_ textField: Any) {

        moveKeyboard(textField: tblViewLokasiList, moveDistance: -250, up: false)
    }


    func moveKeyboard(textField : Any , moveDistance: Float, up:Bool)
    {
        let MoveDuration = 0.3
        _ = CGFloat(up ? moveDistance : -moveDistance)

        UIView.beginAnimations("moveTextfield", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(MoveDuration)
        UIView.commitAnimations()
    }
    
}

extension LokasiList: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchCompleter.queryFragment = searchText
        
    }
}
