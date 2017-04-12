/*
*
* OrangeTrustBadge
*
* File name:   LandingController.swift
* Created:     15/12/2015
* Created by:  Romain BIARD
*
* Copyright 2015 Orange
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import UIKit

class LandingController: UITableViewController {
    
    static let defaultReuseIdentifier = "DefaultCell"
    
    var mainGestureRecognizer : UIGestureRecognizer?
    var usageGestureRecognizer : UIGestureRecognizer?
    @IBOutlet weak var header : Header!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = Helper.localizedString("landing-title")
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad{
            self.clearsSelectionOnViewWillAppear = false
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: LandingController.defaultReuseIdentifier)
        tableView.estimatedRowHeight = 70
        NotificationCenter.default.post(name: Notification.Name(rawValue: TrustBadgeManager.TRUSTBADGE_ENTER), object: nil)
        
        mainGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LandingController.goToMainElements(_:)))
        usageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LandingController.goToUsageElements(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        header.title.text = Helper.localizedString("landing-header-title")
        header.title.textColor = TrustBadgeManager.sharedInstance.config?.headerTextColor
        self.manageLogoVisibility()
        self.tableView.reloadData()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.manageLogoVisibility()
        self.tableView.reloadData()
    }
    
    /**
     Hide the logo on MasterView when sizeClass != .Compact (e.g on iPad and Iphone6 Plus for instance)
     */
    func manageLogoVisibility(){
        if let header = self.header{
            if (self.splitViewController?.traitCollection.horizontalSizeClass != .compact) {
                header.logo.isHidden = true
                header.hiddingConstraint.priority = 999
            } else {
                header.logo.isHidden = false
                header.hiddingConstraint.priority = 250
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch((indexPath as NSIndexPath).row) {
        case 0 :
            if (self.splitViewController?.traitCollection.horizontalSizeClass == .compact) {
                let cell = tableView.dequeueReusableCell(withIdentifier: ElementMenuCell.reuseIdentifier, for: indexPath) as! ElementMenuCell
                cell.title.text = Helper.localizedString("landing-permission-title")
                cell.content.text = Helper.localizedString("landing-permission-content")
                cell.representedObject = TrustBadgeManager.sharedInstance.mainElements
                cell.overview.reloadData()
                cell.overview.removeGestureRecognizer(mainGestureRecognizer!)
                cell.overview.removeGestureRecognizer(usageGestureRecognizer!)
                cell.overview.addGestureRecognizer(mainGestureRecognizer!)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: LandingController.defaultReuseIdentifier, for: indexPath)
                cell.textLabel?.text = Helper.localizedString("landing-permission-title")
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                return cell
            }
        case 1 :
            if (self.splitViewController?.traitCollection.horizontalSizeClass == .compact) {
                let cell = tableView.dequeueReusableCell(withIdentifier: ElementMenuCell.reuseIdentifier, for: indexPath) as! ElementMenuCell
                cell.title.text = Helper.localizedString("landing-usages-title")
                cell.content.text = Helper.localizedString("landing-usages-content")
                cell.representedObject = TrustBadgeManager.sharedInstance.usageElements
                cell.overview.reloadData()
                cell.overview.removeGestureRecognizer(mainGestureRecognizer!)
                cell.overview.removeGestureRecognizer(usageGestureRecognizer!)
                cell.overview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LandingController.goToUsageElements(_:))))
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: LandingController.defaultReuseIdentifier, for: indexPath)
                cell.textLabel?.text = Helper.localizedString("landing-usages-title")
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                return cell
            }
        case 2 :
            if (self.splitViewController?.traitCollection.horizontalSizeClass == .compact) {
                let cell = tableView.dequeueReusableCell(withIdentifier: TermsMenuCell.reuseIdentifier, for: indexPath) as! TermsMenuCell
                cell.title.text = Helper.localizedString("landing-terms-title")
                cell.content.text = Helper.localizedString("landing-terms-content")
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: LandingController.defaultReuseIdentifier, for: indexPath)
                cell.textLabel?.text = Helper.localizedString("landing-terms-title")
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
                return cell
            }
            
        default :
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (self.splitViewController?.traitCollection.horizontalSizeClass == .compact) {
            return UITableViewAutomaticDimension
        } else {
            return 55
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch ((indexPath as NSIndexPath).row){
        case 0 :
            self.performSegue(withIdentifier: "Permissions", sender: self)
        case 1 :
            self.performSegue(withIdentifier: "Usages", sender: self)
        case 2 :
            self.performSegue(withIdentifier: "Terms", sender: self)
        default :
            break
        }
    }
    
    // MARK
    
    @IBAction func dismissModal(){
        self.splitViewController?.preferredDisplayMode = .primaryHidden
        self.splitViewController?.dismiss(animated: true, completion: { () -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: TrustBadgeManager.TRUSTBADGE_LEAVE), object: nil)
        })
    }
    
    @objc func goToMainElements(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.performSegue(withIdentifier: "Permissions", sender: self)
        }
    }
    
    @objc func goToUsageElements(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.performSegue(withIdentifier: "Usages", sender: self)
        }
    }
    
}
