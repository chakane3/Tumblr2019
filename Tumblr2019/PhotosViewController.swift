//
//  PhotosViewController.swift
//  Tumblr2019
//
//  Created by Chakane Shegog on 11/23/19.
//  Copyright © 2019 Chakane Shegog. All rights reserved.
//

import UIKit
import AlamofireImage
class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    // This is a property that needs to be initialized
    // right now were saying this is an empty array
    var posts: [[String: Any]] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        retrievePosts()
        // Do any additional setup after loading the view.
    }
    
    // A network request collects data
    private func retrievePosts(){
        // Obtaining url of the API
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        
        
        // Creates a session (makes the network request
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
        
        
        // Configure request cache policy. These are just configurations for how the caching is done
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        
        // Create a task the session is part of
        let task = session.dataTask(with: url) { (data, response, error) in
            // If theres and error print the error
            if let error = error {
                print(error.localizedDescription)
                
                
             // If not, well look for data
             // The response is giving in data and we serializse it into JSON which is a string so we can extract the data we want.
             // In this case we serialize the data into a dictionary and print it out
             } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(dataDictionary)

                // TODO: Get the posts and store in posts property
                // TODO: Reload the table view
                
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosTableViewCell", for: indexPath) as! PhotosTableViewCell
        
        // Collect the post
        let post = posts[indexPath.row]
        
        // this is when u are not sure the type of going to cast
        if let photos = post["photos"] as? [[String: Any]] {
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String: Any]
            let urlString = originalSize["url"] as! String
            let url = URL(string: urlString)
            cell.photoImageView.af_setImage(withURL: url!)
            
        }
        return cell
    }
}
