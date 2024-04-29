//
//  MembersViewController.swift
//  TechnicalTest__Arpit
//
//  Created by Ravi Chokshi on 28/04/24.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class MembersViewController: UIViewController {
    @IBOutlet weak var tableViewMembers: UITableView!
    
    var membersArray = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUPTableView()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = "Members"
        

       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMembers()
    }
    
    func loadMembers() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        Loader.show()
        ref.observeSingleEvent(of: .value, with: { snapshot in
//            print("snapshot \(snapshot)")
            Loader.hide()
            self.membersArray.removeAll()
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                guard let restDict = rest.value as? [String: Any] else { continue }
                for key in restDict.keys {
                    let restDict = restDict[key] as? [String: Any] ?? [String: Any]()
                    self.membersArray.append(restDict)
                }
                self.tableViewMembers.reloadData()
            }
        })
    }
    func setUPTableView() {
        tableViewMembers.estimatedRowHeight = 100.0
        // Do any additional setup after loading the view.
        tableViewMembers.register(UINib(nibName: "MembersTableViewCell", bundle: nil), forCellReuseIdentifier: "MembersTableViewCell")
    }

}
//MARK: Table View Delegate and Data Source
extension MembersViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.membersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MembersTableViewCell", for: indexPath) as! MembersTableViewCell
            let memberInfo = self.membersArray[indexPath.row]
            cell.setUpMemberData(memberInfo: memberInfo)
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterViewControllerForUpdate") as! RegisterViewController
        vc.loggedInUserInfo = self.membersArray[indexPath.row]
        vc.isComingFromList = true
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)

    }
    

}
