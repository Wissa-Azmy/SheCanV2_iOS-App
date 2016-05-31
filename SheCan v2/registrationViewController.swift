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
            
            displayAlert("Done", message: "You are successfully registered")
            
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
