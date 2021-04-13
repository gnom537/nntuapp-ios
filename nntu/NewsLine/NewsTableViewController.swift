//
//  NewsTableViewController.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 19.02.2020.
//  Copyright © 2020 Алексей Шерстнёв. All rights reserved.
//

import UIKit

//MARK: - extension
extension UIImageView {
   func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
      URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
   }
   func downloadImage(from url: URL) {
      getData(from: url) {
         data, response, error in
         guard let data = data, error == nil else {
            return
         }
         DispatchQueue.main.async() {
            self.image = UIImage(data: data)
         }
      }
   }
}

class NewsTableViewController: UITableViewController {
    @objc func refresh(){
        getInfoFromNet(completion: { WhatToReturn in
            if WhatToReturn == "" {
                self.title = NSLocalizedString("Ошибка", comment: "")
                let genator = UINotificationFeedbackGenerator()
                genator.notificationOccurred(.error)

            } else {
                self.title = NSLocalizedString("Новости", comment: "")
            }
            self.toConvert = WhatToReturn
            self.theData = scrape(html: self.toConvert)
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        })
    }
    
    var howManyImages = 0
    var images = [UIImageView]()
    var theData = [article](repeating: article(preview: nil, zag: NSLocalizedString("Загрузка новости...", comment: ""), href: nil, text: nil, hqimage: nil) , count: 9)
    var toConvert: String? = nil
    
    //MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = "Загрузка..."
        
        getInfoFromNet(completion: { WhatToReturn in
            if WhatToReturn == "" {
                self.title = NSLocalizedString("Ошибка", comment: "")
            } else {
                self.title = NSLocalizedString("Новости", comment: "")
            }
            self.toConvert = WhatToReturn
            self.theData = scrape(html: self.toConvert)
            //print (theData)
//            if self.theData.count != 0 {
//                for i in 0...self.theData.count - 1 {
//                safelyGetHtmlFromHref(input: self.theData[i], completition: ({ gotten in
//                    self.theData[i] = gotten
//                    //print ("оно загрузилось")
//                }))
//            }
//            }
            self.tableView.reloadData()
        })
        self.refreshControl?.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        //self.tableView.register(NewsViewCell.self, forCellReuseIdentifier: "NewsViewCell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if theData.count == 0 {
            viewDidLoad()
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //MARK: numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return theData.count
    }

    
    //MARK: tableView -> cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ident = "NewsViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ident, for: indexPath) as? NewsViewCell else {
            fatalError("что-то с рулём")
        }
        cell.contentView.isUserInteractionEnabled = true
        
        var tempArticle = theData[indexPath.row]
        
        if (tempArticle.preview == nil) {
            cell.contentView.isUserInteractionEnabled = false
        }
        
        //Логика для картинки - данные подгружаются тогда, когда ссылка есть, а данных нет
        cell.NewsImage.image = UIImage(named: "logoPlaceholder")
        if (tempArticle.preview != nil && tempArticle.Preview == nil){
            tempArticle.Preview = UIImageView()
            tempArticle.Preview?.downloadImage(from: URL(string: tempArticle.preview!)!)
            cell.NewsImage.downloadImage(from: URL(string: tempArticle.preview!)!)
            //cell.NewsImage.downloadImage(from: URL(string: tempArticle.preview!)!)
        }
        if (tempArticle.hqimage != nil && tempArticle.HQimage == nil){
            tempArticle.HQimage = UIImageView()
            //tempArticle.HQimage?.downloadImage(from: URL(string: tempArticle.hqimage!)!)
            //cell.NewsImage.downloadImage(from: URL(string: tempArticle.hqimage!)!)
            //print (tempArticle.hqimage)
        }
        if (tempArticle.HQimage != nil){
            cell.NewsImage.image = tempArticle.HQimage?.image
        } else if (tempArticle.Preview != nil) {cell.NewsImage.image = tempArticle.Preview?.image}
        
        if (tempArticle.text == nil){
            tempArticle.text = ""
        }
        
        cell.NewsImage.backgroundColor = UIColor.secondarySystemBackground
        cell.Article = tempArticle.text
        cell.NewsHeadline.text = tempArticle.zag
        cell.href = tempArticle.href
        
        return cell
    }
    
    
    func getCellFromButton(input : UIButton) -> NewsViewCell {
        let cell = input.superview?.superview?.superview as! NewsViewCell
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let button = sender as! UIButton
        let cell = getCellFromButton(input: button)
        let goToVC = segue.destination as! ArticleTableViewController
        goToVC.theArticleFromSegue = cell
        
        
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}
