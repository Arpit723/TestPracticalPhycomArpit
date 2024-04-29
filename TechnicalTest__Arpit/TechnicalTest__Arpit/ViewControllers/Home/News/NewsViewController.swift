//
//  NewsViewController.swift
//  TechnicalTest__Arpit
//
//  Created by Ravi Chokshi on 27/04/24.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var tableViewNews: UITableView!
    let refreshControl = UIRefreshControl()
    let newsViewModel = NewsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        setUPTableView()
        let articles =  RealmDBManager.shared.getObjectsFromDatabse()
        if articles.count == 0 {
            Loader.show()
            refresh()
        } else {
            self.newsViewModel.newsArray = articles
            self.updateUI(welcome: Welcome())
        }
    }
    

    func setUPTableView() {
        tableViewNews.estimatedRowHeight = 100.0
        // Do any additional setup after loading the view.
        tableViewNews.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableViewNews.addSubview(refreshControl)
    }
   

}


//MARK: Table View Delegate and Data Source
extension NewsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.newsViewModel.newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
            let article = self.newsViewModel.newsArray[indexPath.row]
            cell.seUpNewsData(article: article)
        
            if cell.lblLink.gestureRecognizers?.count == 0 {
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                cell.lblLink.addGestureRecognizer(tap)
            }
            cell.lblLink.tag = indexPath.row
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
        vc.newsDetail = self.newsViewModel.newsArray[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
            let tag = sender?.view?.tag ?? 0
            let next = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsWebViewController.swift") as! NewsWebViewController
            next.newsUrlString = self.newsViewModel.newsArray[tag].url
            next.titleNavigationBar = self.newsViewModel.newsArray[tag].author
            self.navigationController?.pushViewController(next, animated: true)
    }

}

extension NewsViewController {
    @objc func refresh() {
        self.apiCallToGetPosts()
    }
    
    func apiCallToGetPosts() {
        newsViewModel.getNewsArticles(completion: { [weak self] result in
            Loader.hide()
            DispatchQueue.main.async {
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let welcome):
                    self.refreshControl.endRefreshing()
                    self.updateUI(welcome: welcome)
                case .failure(let error):
                    print("Error:\(error.localizedDescription)")
                }
            }
            
        })
    }
    
    func updateUI(welcome: Welcome) {
//        print("Posts count \(welcome.articles.count)")
        tableViewNews.reloadData()
    }}
