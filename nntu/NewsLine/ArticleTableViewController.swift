//
//  ArticleTableViewController.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 19.02.2020.
//  Copyright © 2020 Алексей Шерстнёв. All rights reserved.
//

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

import UIKit

class ArticleTableViewController: UITableViewController {
    
    var theArticleFromSegue: NewsViewCell = NewsViewCell()
    var theArticle = article()

    override func viewDidLoad() {
        super.viewDidLoad()
        theArticle.href = theArticleFromSegue.href
//        safelyGetHtmlFromHref(input: theArticle, completition: ({ loaded in
//            self.theArticle = loaded
//            self.theArticleFromSegue.Article = loaded.text
//            if (loaded.text == "" || loaded.text == nil) {
//                self.theArticleFromSegue.Article = "Не удалось загрузить новость"
//            }
//            self.tableView.reloadData()
//        }))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Article", for: indexPath) as? ArticleTableViewCell else {
            fatalError("Ячейка не прогрузилась")
        }
        
        cell.Headline.text = theArticleFromSegue.NewsHeadline.text
        cell.ArticleImage.image = theArticleFromSegue.NewsImage.image
        cell.TheArticle.text = theArticleFromSegue.Article
        cell.ArticleImage.backgroundColor = UIColor.secondarySystemBackground
        
        
        
        let imageHeight = cell.ArticleImage.image?.size.height ?? 3
        let imageWidth = cell.ArticleImage.image?.size.width ?? 4
        let proportion = imageHeight/imageWidth
        cell.ImageHeight.constant = proportion * (UIScreen.main.bounds.width - 20)
        if cell.TheArticle.text == "" {
            cell.TheArticle.text = "Загрузка..."
        }
        
        
        //cell.ArticleImage.layer.cornerRadius = 5
        //cell.ArticleImage.clipsToBounds = true
        
        let screen = UIScreen.main
        
        
        self.tableView.rowHeight = (cell.TheArticle.text?.height(withConstrainedWidth: screen.bounds.width - 30, font: .systemFont(ofSize: 17)) as! CGFloat) + (cell.Headline.text?.height(withConstrainedWidth: screen.bounds.width - 30, font: .systemFont(ofSize: 20)) as! CGFloat) + cell.ImageHeight.constant + 60
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}


