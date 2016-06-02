//
//  registrationViewController.swift
//  SheCan v2
//
//  Created by Wissa Azmy on 5/30/16.
//  Copyright © 2016 Wissa Azmy. All rights reserved.
//

import UIKit

class registrationViewController: UIViewController {
    
    
    @IBOutlet weak var nameField: UITextField!

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    
    
    func displayAlert (title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        if title == "Done" {
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
                action in self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }else {
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpBtn() {
        if nameField.text == "" || emailField.text == "" || phoneField.text == "" || passwordField.text == "" || confirmPasswordField.text == "" {
            displayAlert("Missing Field(s)", message: "All Fields are required")
            
        } else if passwordField.text != confirmPasswordField.text {
            displayAlert("Invalid Passwowrd", message: "Password fields do not match")
            
        } else {
            let name = nameField.text
            let email = emailField.text
            let phone = phoneField.text
            let password = passwordField.text
            
            // Request Configuration
            let url = NSURL(string: "http://localhost/iOS/PhP_test_Server/userRegister.php")
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            
            // Send the data in the request body
            let postString = "email=\(email!)&password=\(password!)&phone=\(phone!)&name=\(name!)"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, request:NSError?) -> Void in
                
                dispatch_async(dispatch_get_main_queue(), {
                    // Display alert message with confirmation
                    self.displayAlert("Done", message: "You're Successfully registered")
                })
                
            }).resume()
            
            
            // Receive Response
//            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
//                data, response, error in
//                if error != nil {
//                    print("error=\(error)")
//                    return
//                }
//                
//                
//                do {
//                    // var err: NSError?
//                    var json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
//                    
//                } catch let err as NSError{
//                    print("Failed to load: \(err)")
//                }
//                
//                if let parseJSON = json {
//                    var resultValue = parseJSON["status"] as? String
//                    print ("result: \(resultValue)")
//                    
//                    var isUserRegistered:Bool = false;
//                    if(resultValue == "Success") { isUserRegistered = true; }
//                    
//                    var messageToDisplay: String = parseJSON["message"] as String!;
//                    if(!isUserRegistered){
//                        messageToDisplay = parseJSON["message"] as String!;
//                    }
//                    
//                    dispatch_async(dispatch_get_main_queue(), {
//                        // Display alert message with confirmation
//                        self.displayAlert("Done", message: messageToDisplay)
//                    })
//                }
//                
//            }
            
//            displayAlert("Done", message: "registration Successful")
            
        }
        
    }

    @IBAction func goToLoginBtn() {
        self.dismissViewControllerAnimated(true, completion: nil)
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
