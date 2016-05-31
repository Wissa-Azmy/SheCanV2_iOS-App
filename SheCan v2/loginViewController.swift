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
            let username = usernameField.text
            let password = passwordField.text
            
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
