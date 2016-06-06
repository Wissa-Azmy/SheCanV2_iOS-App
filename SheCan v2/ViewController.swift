//
//  ViewController.swift
//  SheCan v2
//
//  Created by Wissa Azmy on 5/30/16.
//  Copyright © 2016 Wissa Azmy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var welcomLbl: UILabel!
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
    
    func displayAlert (title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        if title == "Success" {
            
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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        let userId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        let userName = NSUserDefaults.standardUserDefaults().stringForKey("userName")
        
        if userId == nil {
            self.performSegueWithIdentifier("loginView", sender: self)
        } else {
            let welcomeText = "Welcome " + userName!
            welcomLbl.text = welcomeText
        }
    }
    
    
    @IBAction func logoutBtn(sender: UIBarButtonItem) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userId")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userName")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let signInPage = self.storyboard?.instantiateViewControllerWithIdentifier("loginViewController")
        
        let signInNav = UINavigationController(rootViewController: signInPage!)
        
        let appDelegate = UIApplication.sharedApplication().delegate
        appDelegate!.window??.rootViewController = signInNav
    }
    

    @IBAction func profilePhotoBtn(sender: UIButton) {
        let myImagePicker = UIImagePickerController()
        myImagePicker.delegate = self
        myImagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myImagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        profilePhoto.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageUpload()
    }
    
    func imageUpload(){
        let url = NSURL(string: "http://localhost/iOS/PhP_test_Server/imageUpload.php")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let userId: String? = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        
        let param = [
            "userId": userId!
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let imageData = UIImageJPEGRepresentation(profilePhoto.image!, 1)
        
        if(imageData==nil) { return; }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
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
                            
//                            let userId = parseJSON["userId"] as? String
                            
                            
                            let msg = parseJSON["message"] as? String
                            self.displayAlert(status!, message: msg!)
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
    
    /// Create body of the multipart/form-data request
    ///
    /// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service
    /// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// - parameter paths:        The optional array of file paths of the files to be uploaded
    /// - parameter boundary:     The multipart/form-data boundary
    ///
    /// - returns:                The NSData of the body of the request
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        
//        if paths != nil {
//            for path in paths! {
//                let url = NSURL(fileURLWithPath: path)
//                let filename = url.lastPathComponent
//                let data = NSData(contentsOfURL: url)!
//                let mimetype = mimeTypeForPath(path)
//                
//                body.appendString("--\(boundary)\r\n")
//                body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename!)\"\r\n")
//                body.appendString("Content-Type: \(mimetype)\r\n\r\n")
//                body.appendData(imageDataKey)
//                body.appendString("\r\n")
//            }
//        }
        
        body.appendString("--\(boundary)--\r\n")
        return body
    }
    
    func generateBoundaryString() -> String {
        // Create and return a unique string 
        return "Boundary-\(NSUUID().UUIDString)"
    }
}


// Make sure that the extension is declared at the end of your main class and after the last curly braces "}"
extension NSMutableData {
    func appendString (string: String){
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}
