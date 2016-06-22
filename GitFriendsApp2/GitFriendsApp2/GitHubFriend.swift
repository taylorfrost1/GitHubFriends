//
//  GitHubFriend.swift
//  GitFriendsApp2
//
//  Created by Taylor Frost on 6/21/16.
//  Copyright © 2016 Taylor Frost. All rights reserved.
//

import UIKit

class GitHubFriend: NSObject {
    
    weak var delegate: GithubAPIDelegate?
    
    //Create a session constant
    let session = NSURLSession.sharedSession()
    
    func fetchGitHubUser(username: String){
        
        //1. Create the urlString that we need
        let urlString = "https://api.github.com/users/\(username)"
        
        //2. Make a NSURL object
        if let url = NSURL(string: urlString) {
            
            //3. Create a dataTask with the URL to get the actual data
            let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error?.localizedDescription)
                    return
                }
                
                if let jsonDictionary = self.parseJSON(data){
                    
                    print("I am in the GitHubFriend controller")
                    print(jsonDictionary)
                    
                    self.delegate?.passDictionary(jsonDictionary)
                    
                } else {
                    print("I could not get the root level dictionary")
                }
                
            })
            task.resume()
            
        } else {
            print("Not a valid url \(urlString)")
        }
        
    }
    
    // This method allows us to send some NSData and get back a JSONDictionary
    
    func parseJSON(data:NSData?) -> JSONDictionary? {
        
        var theDictionary : JSONDictionary? = nil
        
        if let data = data {
            do {
                
                if let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? JSONDictionary {
                    
                    
                    theDictionary = jsonDictionary
                    
                    //                print (jsonDictionary)
                    
                    
                } else {
                    print("Could not parse the jsonDictionary")
                }
                
            } catch {
                
            }
            
        } else {
            print("Could not unwrap data")
            
        }
        
        return theDictionary
        
    }

}
