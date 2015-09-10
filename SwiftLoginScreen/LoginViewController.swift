//
//  LoginViewController.swift
//  SwiftLoginScreen
//
//  Created by Shunchao Wang on 8/3/2015.
//  Copyright (c) 2015 swang. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signinButtonPressed(sender: UIButton) {
        
        var homeVC: ViewController = ViewController()
        var serviceUrl: NSString = homeVC.serviceUrl + homeVC.serviceAuthenticateRequest
        var apiKey: NSString = homeVC.apiKey
        var username:NSString = usernameText.text
        var password:NSString = passwordText.text
        
        if (username.isEqualToString("") || password.isEqualToString("")) {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed"
            alertView.message = "Please input username and password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            var params: NSString = "username=\(username)&password=\(password)"
            var requestUrl = "\(serviceUrl)?\(params)"
            NSLog("Request Data: %@", params)
            NSLog("Request Url: %@", requestUrl)
            var url:NSURL = NSURL(string: requestUrl)!
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            
            var responseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &responseError)
            
            if (urlData != nil) {
                
                NSLog("NSData: %@", NSString(data: urlData!, encoding: NSUTF8StringEncoding)!)
                let res = response as! NSHTTPURLResponse
                NSLog("Response ==> %ld", res.statusCode)
                
                if (res.statusCode >= 200 && res.statusCode < 300) {
                    var responseData: NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
                    NSLog("Response ==> %@", responseData)
                    
                    var error: NSError?
                    let jsonData: Array<NSDictionary> = NSJSONSerialization.JSONObjectWithData(urlData!,
                        options: NSJSONReadingOptions.MutableContainers, error: &error) as! Array<NSDictionary>
                    NSLog("jsondata: %@", jsonData)
                    
                    let success: Bool = jsonData[0].valueForKey("success") as! Bool
                    NSLog("Success: %@", success)
                    if (success == true) {
                        NSLog("Login SUCCESS")
                        let siteId: Int = jsonData[0].valueForKey("siteId") as! Int
                        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        prefs.setObject(username, forKey: "USERNAME")
                        prefs.setInteger(1, forKey: "ISLOGGEDIN")
                        prefs.setInteger(siteId, forKey: "SITEID")
                        prefs.synchronize()
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        var message: NSString
                        
                        if jsonData[0]["message"] as? NSString != nil {
                            message = jsonData[0]["message"] as! NSString
                        } else {
                            message = "Unknown Error"
                        }
                        
                        var alertView: UIAlertView = UIAlertView()
                        alertView.title = "Sign in Failed!"
                        alertView.message = message as String
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                    }
                } else { // code is not between 200 and 300
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            } else { // http request return data is nil
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = responseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
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
