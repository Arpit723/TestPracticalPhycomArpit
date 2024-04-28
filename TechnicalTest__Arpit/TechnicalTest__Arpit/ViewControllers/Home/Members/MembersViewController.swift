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
    
    var membersArray = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUPTableView()
        self.title = "Members"
        var ref: DatabaseReference!
        ref = Database.database().reference()
        Loader.show()
        ref.observeSingleEvent(of: .value, with: { snapshot in
//            print("snapshot \(snapshot)")
            Loader.hide()

            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                guard let restDict = rest.value as? [String: Any] else { continue }
                for key in restDict.keys {
                    let restDict = restDict[key] as? [String: String] ?? [String: String]()
                    self.membersArray.append(restDict)
                }
                self.tableViewMembers.reloadData()
            }
        })

//        ref.observeSingleEvent(of: .childChanged, with: { snapshot in
//            print("snapshot \(snapshot)")
//            self.membersArray.removeAll()
//            for rest in snapshot.children.allObjects as! [DataSnapshot] {
//                guard let restDict = rest.value as? [String: Any] else { continue }
//                for key in restDict.keys {
//                    let restDict = restDict[key] as? [String: String] ?? [String: String]()
//                    self.membersArray.append(restDict)
//                }
//                self.tableViewMembers.reloadData()
//            }
//        })

        // Do any additional setup after loading the view.
    }
    func setUPTableView() {
        tableViewMembers.estimatedRowHeight = 100.0
        // Do any additional setup after loading the view.
        tableViewMembers.register(UINib(nibName: "MembersTableViewCell", bundle: nil), forCellReuseIdentifier: "MembersTableViewCell")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterViewControllerForUpdate") as! RegisterViewController
//        vc.loggedInUserInfo = self.membersArray[indexPath.row]
//        vc.isComingFromList = true
//        self.navigationController?.pushViewController(vc, animated: true)

    }
    

}
