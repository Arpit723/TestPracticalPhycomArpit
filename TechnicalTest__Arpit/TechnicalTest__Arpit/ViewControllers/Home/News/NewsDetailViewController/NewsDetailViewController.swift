//
//  PostDetailViewController.swift
//  IOSTest_Arpit
//
//  Created by Ravi Chokshi on 25/04/24.
//

import UIKit

class NewsDetailViewController: UIViewController {

    var newsDetail: Article?
    @IBOutlet weak var lblNewsTitle: UILabel!
    @IBOutlet weak var imgvNews: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSource: UILabel!
    @IBOutlet weak var lblLink: UnderlinedLabel!

    @IBOutlet weak var lblBody: UILabel!
//    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblId: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = newsDetail?.author ?? ""
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.lblLink.addGestureRecognizer(tap)
        
        loadData()
    }

    func loadData() {
        lblNewsTitle.text = String(newsDetail?.title ?? "")
        lblDate.text = Utility.dateFormatterForPublishedAt(dateString: String(newsDetail?.publishedAt ?? ""))
        lblSource.text = String(newsDetail?.source?.name ?? "")
        lblLink.text = String(newsDetail?.url ?? "")
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        let next = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsWebViewController") as! NewsWebViewController
        next.newsUrlString = self.newsDetail?.url ?? ""
        next.titleNavigationBar = self.newsDetail?.author ?? ""
        self.navigationController?.pushViewController(next, animated: true)
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
