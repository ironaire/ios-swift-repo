//
//  ViewController.swift
//  SwiftLoginScreen
//
//  Created by Shunchao Wang on 7/31/2015.
//  Copyright (c) 2015 swang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var serviceUrl: String = "http://localhost:8081/ready-service"
    var serviceAuthenticateRequest: String = "/general/authenticate"
    var serviceSiteRequest: String = "/sites"
    var serviceSiteConfigProfileRequest: String = "/configProfiles"
    var serviceSiteProviderRequest: String = "/providers"
    var apiKey = "jHsYiWWRZDq5Sq3N"
    
    var providers = [String]()
    var configProfiles = [String]()
    
    var pickerDataSource = ["White", "Red", "Green", "Blue"]
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var providerPicker: UIPickerView!
    @IBOutlet weak var configProfilePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.providerPicker.dataSource = self
        self.providerPicker.delegate = self
        self.configProfilePicker.dataSource = self
        self.configProfilePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if(isLoggedIn != 1) {
            self.performSegueWithIdentifier("loginSegue", sender: self)
        } else {
            var username = prefs.valueForKey("USERNAME") as! NSString as String
            self.welcomeLabel.text = "Welcome \(username)"
            providers = loadProviders()
            self.providerPicker.reloadAllComponents()
            configProfiles = loadConfigProfiles()
            self.configProfilePicker.reloadAllComponents()
        }
    }

    @IBAction func logoutButtonPressed(sender: UIButton) {
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        self.performSegueWithIdentifier("loginSegue", sender: self)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
               return 1
    }
    
    func retrieveLoginSite() -> Int {
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if(isLoggedIn == 1) {
            return prefs.integerForKey("SITEID") as Int
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if (pickerView.tag == 0) { // provider picker
            return providers.count
        } else if (pickerView.tag == 1) { // config profile picker
            return configProfiles.count
        } else {
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        if (pickerView.tag == 0) { // provider picer
            return providers[row]
        } else if (pickerView.tag == 1) {
            return configProfiles[row]
        }
            return ""
    }
    
    func loadProviders() -> [String] {
        
        var result: [String] = [String]()
        var loginSiteId: Int = retrieveLoginSite()
        if(loginSiteId == 0) {
            return result
        }
        var requestUrl: NSString = "\(self.serviceUrl)\(self.serviceSiteRequest)/\(loginSiteId)\(self.serviceSiteProviderRequest)"
        NSLog("Request Url: %@", requestUrl)
        var url:NSURL = NSURL(string: requestUrl as String)!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(self.apiKey)", forHTTPHeaderField: "Authorization")
        
        var responseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &responseError)
        NSLog("NSData: %@", NSString(data: urlData!, encoding: NSUTF8StringEncoding)!)
        
        if (urlData != nil) {
            let res = response as! NSHTTPURLResponse
            NSLog("Response ==> %ld", res.statusCode)
            
            if (res.statusCode >= 200 && res.statusCode < 300) {
                var responseData: NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
                NSLog("Response ==> %@", responseData)
                
                var error: NSError?
                let jsonData: Array<NSDictionary> = NSJSONSerialization.JSONObjectWithData(urlData!,
                    options: NSJSONReadingOptions.MutableContainers, error: &error) as! Array<NSDictionary>
                NSLog("jsondata: %@", jsonData)
                
                // iterate the array result
                for json: NSDictionary in jsonData {
                    var firstName = json.valueForKey("firstName") as! String
                    var lastName = json.valueForKey("lastName") as! String
                    var npi = json.valueForKey("npi") as! String
                    result.append("\(firstName) \(lastName) \(npi)")
                }
                
            } else { // code is not between 200 and 300
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Loading Provider Failed!"
                alertView.message = "Connection Failed"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        } else { // http request return data is nil
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Load Provider Failed!"
            alertView.message = "Connection Failure"
            if let error = responseError {
                alertView.message = (error.localizedDescription)
            }
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }

        return result
    }
    
    func loadConfigProfiles() -> [String] {
        
        var result: [String] = [String]()
        var loginSiteId: Int = retrieveLoginSite()
        if(loginSiteId == 0) {
            return result
        }
        var requestUrl: NSString = "\(self.serviceUrl)\(self.serviceSiteRequest)/\(loginSiteId)\(self.serviceSiteConfigProfileRequest)"
        NSLog("Request Url: %@", requestUrl)
        var url:NSURL = NSURL(string: requestUrl as String)!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(self.apiKey)", forHTTPHeaderField: "Authorization")
        
        var responseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &responseError)
        NSLog("NSData: %@", NSString(data: urlData!, encoding: NSUTF8StringEncoding)!)
        
        if (urlData != nil) {
            let res = response as! NSHTTPURLResponse
            NSLog("Response ==> %ld", res.statusCode)
            
            if (res.statusCode >= 200 && res.statusCode < 300) {
                var responseData: NSString = NSString(data: urlData!, encoding: NSUTF8StringEncoding)!
                NSLog("Response ==> %@", responseData)
                
                var error: NSError?
                let jsonData: Array<NSDictionary> = NSJSONSerialization.JSONObjectWithData(urlData!,
                    options: NSJSONReadingOptions.MutableContainers, error: &error) as! Array<NSDictionary>
                NSLog("jsondata: %@", jsonData)
                
                // iterate the array result
                for json: NSDictionary in jsonData {
                    var name = json.valueForKey("name") as! String
                    var defaultConfig = json.valueForKey("defaultConfig") as! Bool
                    if (defaultConfig) {
                        result.append("\(name) *")
                    } else {
                        result.append("\(name)")
                    }
                }
                
            } else { // code is not between 200 and 300
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Loading ConfigProfile Failed!"
                alertView.message = "Connection Failed"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        } else { // http request return data is nil
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Load ConfigProfile Failed!"
            alertView.message = "Connection Failure"
            if let error = responseError {
                alertView.message = (error.localizedDescription)
            }
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        
        return result

    }

}

