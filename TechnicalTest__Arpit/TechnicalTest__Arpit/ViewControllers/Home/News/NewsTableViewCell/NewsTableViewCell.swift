//
//  PostTableViewCell.swift
//  IOSTest_Arpit
//
//  Created by Ravi Chokshi on 25/04/24.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var lblLink: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UnderlinedLabel!
    var newsInfo: Article?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
      

    }

    func seUpNewsData(article: Article) {
        self.newsInfo = article
        self.lblTitle.text = article.title
        self.lblAuthor.text = article.author
        self.lblDate.text = Utility.dateFormatterForPublishedAt(dateString: article.publishedAt)
        self.lblLink.text = article.url
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
