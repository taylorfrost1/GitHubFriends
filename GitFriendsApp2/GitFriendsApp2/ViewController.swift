//
//  ViewController.swift
//  GitFriendsApp2
//
//  Created by Taylor Frost on 6/21/16.
//  Copyright © 2016 Taylor Frost. All rights reserved.
//

import UIKit

protocol GithubAPIDelegate : class {
    func  passDictionary(dict: JSONDictionary)
    
}

class ViewController: UIViewController, GithubAPIDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLable: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    
    let apiController = GitHubFriend()
    
    var imageURLString : String = ""
    var nameString : String = ""
    var loginString : String = ""
    var gitHubIDInt : Int = 0
    var emailString : String = ""
    var publicReposInt : Int = 0
    var publicGistsInt : Int = 0
    var followersInt : Int = 0
    var followingInt : Int = 0
    var createdAtString : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        //IMPORTANT MUST ASSIGN THE DELEGATE
        self.apiController.delegate = self
        
        print("I just called viewDidLoad")
        
        self.apiController.fetchGitHubUser("taylorfrost1")
        
    }
    
    func passDictionary(dict: JSONDictionary) {
        // Do something with the delegate
        
        print("I am in the ViewController!")
        
        if let avatarURL = dict["avatar_url"] as? String {
            self.imageURLString = avatarURL
            self.getImageFromURLString(self.imageURLString)
            
        } else {
            print("I couldn't parse the avatar_url")
        }
        
        if let gitName = dict["name"] as? String {
            self.nameString = gitName
            self.nameLabel.text = gitName
            
        } else {
            print("I could not parse the name")
        }
        
        if let username  = dict ["login"] as? String {
            self.loginString = username
            self.usernameLable.text = username
        
        } else {
            print("I could not parse the login")
        }
        
        if let gitHubID = dict ["id"] as? Int {
            self.gitHubIDInt = gitHubID
            
        } else {
            print("I could not parse the id")
        }
        
        if let email = dict ["email"] as? String {
            self.emailString = email
            self.emailLabel.text = email
       
        } else {
            print("I could not parse the email")
        }
        
        if let publicRepos = dict ["public_repos"] as? Int{
            self.publicReposInt = publicRepos
        
        } else {
            print("I could not parse the publicRepos")
        }
        
        if let publicGists = dict ["public_gists"] as? Int{
            self.publicGistsInt = publicGists
        } else {
            print("I could not parse the publicGists")
        }
        
        if let followers = dict ["followers"] as? Int{
            self.followersInt = followers
            self.followersLabel.text = "Followers \(String(followers))"
            
        } else {
            print("I could not parse the followers")
        }
        
        if let following = dict ["following"] as? Int{
            self.followingInt = following
            self.followingLabel.text = "Following \(String (following))"
        
        } else {
            print("I could not parse the followingInt")
        }
        
        if let createdAt = dict ["created_at"] as? String {
            self.createdAtString = createdAt
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let dateObj = dateFormatter.dateFromString(createdAt)
            dateFormatter.dateFormat = "MMM d, yyyy"
            self.createdLabel.text = "Account Created \(dateFormatter.stringFromDate(dateObj!))"
        
        } else {
            print("I could not parse the createdAtString")
        }
        
    }
    
    func getImageFromURLString(urlString: String) {
    
        
        //Convert from string to NSURL
        if let url = NSURL(string: urlString) {
            
            let session = NSURLSession.sharedSession()
            
            
            // This is a closure
            let task = session.dataTaskWithURL(url, completionHandler: {(data, response, error) in
                
                if error != nil {
                    print(error?.localizedDescription)
                    return
                    
                }
                
                //Unwrapping
                if let data = data {
                    
                    let image = UIImage(data:data)
                    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.imageView.image = image
                        
                        
                    })
                    
                }
                
            })
            task.resume()
            
        } else {
            print("Not a valid url \(urlString)")
            
        }
    }

}

