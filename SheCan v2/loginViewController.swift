//
//  loginViewController.swift
//  SheCan v2
//
//  Created by Wissa Azmy on 5/30/16.
//  Copyright © 2016 Wissa Azmy. All rights reserved.
//

import UIKit

class loginViewController: UIViewController {
    
    

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    // Function that displays alert message to the user
    func displayAlert (title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // To Dismiss the keyboard when Tapping anywhere on the screen
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // Delegate Fields that will activate the hide Keyboard function when return key touched
//        self.usernameField.delegate = self
//        self.passwordField.delegate = self
    }
    
    // This func is called by the Tap constant above when the screen is tapped.
    func DismissKeyboard() {
        view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginBtn() {
        // Check if the Fields are empty
        if usernameField.text == "" || passwordField.text == "" {
            displayAlert("Missing Field(s)", message: "Username and password are required")
        } else {
            let email = usernameField.text
            let password = passwordField.text
            
            // Request Configuration
            let url = NSURL(string: "http://localhost/iOS/PhP_test_Server/userLogin.php")
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            
            // Send the data in the request body
            let postString = "&password=\(password!)&email=\(email!)"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if error != nil{
                        self.displayAlert("Error", message: (error?.localizedDescription)!)
                    }
                    
                    do {
                        
                        // Parse the JSON retrieved Data
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                        
                        if let parseJSON = json {
                            let status = parseJSON["status"] as? String
                            if status == "Success" {
                                NSUserDefaults.standardUserDefaults().setObject(parseJSON["id"], forKey: "userId")
                                NSUserDefaults.standardUserDefaults().setObject(parseJSON["username"], forKey: "userName")
                                NSUserDefaults.standardUserDefaults().synchronize()
                                
                                
                                let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController")
                                let mainPageNav = UINavigationController(rootViewController: mainPage!)
                                let appDelegate = UIApplication.sharedApplication().delegate
                                appDelegate?.window??.rootViewController = mainPageNav
                                
                                
//                                 let msg = parseJSON["message"] as? String
//                                self.displayAlert(status!, message: msg!)
                            } else {
                                let msg = parseJSON["message"] as? String
                                self.displayAlert(status!, message: msg!)
                            }
                        }
                        
                    } catch {
                        print("bad things happened")
                    }
                    
                }
                
            }).resume()

        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
