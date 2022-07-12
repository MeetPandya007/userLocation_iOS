//
//  ViewController.swift
//  TheOneTask
//
//  Created by Meet on 12/07/22.
//

import UIKit

class ViewController: UIViewController {

//MARK: Variable declaration
    var db = DBManager()
    var persons = [Person]()
    
//MARK: Outlets declaration
    @IBOutlet weak var tableview: UITableView!
    
//MARK: View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        persons = db.read()
        
        if persons.count == 0{
            fetchDetails()
        }
    }
}

//MARK: - tableview methods
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        }
    
        var config = cell?.defaultContentConfiguration()
        config?.text = persons[indexPath.row].name
        config?.secondaryText = persons[indexPath.row].vicinity
        cell?.contentConfiguration = config
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        vc.person = persons[indexPath.row]
        self.present(vc, animated: true)
        
    }
    
}

//MARK: - Custom methods
extension ViewController{
    func fetchDetails() {
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/search/json?location=23.03744,72.566&rankby=distance&types=bakery&sensor=true&key=AIzaSyB2Az9gVUzQULUc55xQD9AE7gj9Ni5hvJk")!

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
            print("Error with fetching films: \(error)")
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
            print("Error with the response, unexpected status code: \(response)")
            return
          }
            
            if let data = data, let dict = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] {
                print(dict)
                let results = dict["results"] as? [[String:Any]]
                for result in results ?? [] {
                    let name = result["name"] as? String ?? ""
                    let geo = result["geometry"] as? [String:Any]
                    let loc = geo?["location"] as? [String:Any]
                    let lat = loc?["lat"] as? Double
                    let lng = loc?["lng"] as? Double
                    let vicinity = result["vicinity"] as? String ?? ""
                    
                    if lat != nil && lng != nil {
                        self.db.insert(name: name, vicinity: vicinity, lat: "\(lat!)", lng: "\(lng!)")
                    }
                }
                self.persons = self.db.read()
                self.tableview.reloadData()
            }
        })
        task.resume()
      }
}
