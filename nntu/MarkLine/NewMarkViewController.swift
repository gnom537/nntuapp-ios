//
//  NewMarkViewController.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 11.03.2020.
//  Copyright © 2020 Алексей Шерстнёв. All rights reserved.
//

import UIKit
import Alamofire

extension Float {
    func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}
class NewMarkViewController: UITableViewController {
    
    //MARK: data for start
    @IBOutlet var SemestrSegment: UISegmentedControl!
    @IBOutlet var FalseSegment: UISegmentedControl!
    @IBOutlet var AverageMarkItem: UIBarButtonItem!
    
    
    var allMarks = multipleSems()
//
//    var markArray: [Int] = []
//    var semsForMarkArray: [Int] = []
    
    //MARK: - refresh()
    @objc func refresh(){
        updateMarkInfo(completion: { (theData, html) in
            self.allMarks = theData
            self.updateSemesters()
            self.tableView.reloadData()
//            print(html)
            
            if (html.contains("не найден")){
                let ok = UIAlertAction(title: NSLocalizedString("Понятно", comment: ""), style: .default)
                let popup = UIAlertController(title: "Студент не найден", message: "Проверьте правильность введённых вами данных", preferredStyle: .alert)
                popup.addAction(ok)
                self.present(popup, animated: true)
                let genator = UINotificationFeedbackGenerator()
                genator.notificationOccurred(.error)
            } else if (self.allMarks.Sems.count == 0){
                let ok = UIAlertAction(title: NSLocalizedString("Понятно", comment: ""), style: .default)
                let popup = UIAlertController(title: "Произошла ошибка при загрузке", message: "Проверьте подключение к интернету", preferredStyle: .alert)
                popup.addAction(ok)
                self.present(popup, animated: true)
                let genator = UINotificationFeedbackGenerator()
                genator.notificationOccurred(.error)
                
            }
            self.fillTheArrays()
            self.refreshControl?.endRefreshing()
        })
    }
    
    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        AverageMarkItem.isEnabled = false
//        updateSemesters()
//        if (tryData.Sems.count == 0){
//            self.title = NSLocalizedString("Загрузка...", comment: "")
//        }
        
        //MARK: updateMarkInfo call
        updateMarkInfo(completion: { (theData, html) in
            self.allMarks = theData
            self.updateSemesters()
            self.tableView.reloadData()
            //print (self.tryData)
            
            self.fillTheArrays()
            
            if (html.contains("не найден")){
                let ok = UIAlertAction(title: NSLocalizedString("Понятно", comment: ""), style: .default)
                let popup = UIAlertController(title: "Студент не найден", message: "Проверьте правильность введённых вами данных", preferredStyle: .alert)
                popup.addAction(ok)
                self.present(popup, animated: true)
                let genator = UINotificationFeedbackGenerator()
                genator.notificationOccurred(.error)
            } else if (self.allMarks.Sems.count == 0){
                let ok = UIAlertAction(title: NSLocalizedString("Понятно", comment: ""), style: .default)
                let popup = UIAlertController(title: "Произошла ошибка при загрузке", message: "Проверьте подключение к интернету", preferredStyle: .alert)
                popup.addAction(ok)
                self.present(popup, animated: true)
                let genator = UINotificationFeedbackGenerator()
                genator.notificationOccurred(.error)
                
            }
            
//            self.title = NSLocalizedString("Оценки", comment: "")
        })
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
                // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        
        // Новые приколы со свайпами (1.04.2021)
        let nextSwipe = UISwipeGestureRecognizer(target: self, action: #selector(nextSem(_:)))
        nextSwipe.direction = .left
        self.tableView.addGestureRecognizer(nextSwipe)
        
        let prevSwipe = UISwipeGestureRecognizer(target: self, action: #selector(prevSem(_:)))
        prevSwipe.direction = .right
        self.tableView.addGestureRecognizer(prevSwipe)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateBadge(self)
    }
    
    //MARK: semestrChanged
    @IBAction func SemestrChanged(_ sender: Any) {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        
        self.tableView.reloadData()
    }
    
    //MARK: prevSem
    @objc func prevSem(_ sender: UISwipeGestureRecognizer){
        if (SemestrSegment.selectedSegmentIndex > 0){
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            
            SemestrSegment.selectedSegmentIndex -= 1
            self.tableView.reloadData()
        }
    }
    
    //MARK: nextSem
    @objc func nextSem(_ sender: UISwipeGestureRecognizer){
        if (SemestrSegment.selectedSegmentIndex < SemestrSegment.numberOfSegments - 1){
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
            
            SemestrSegment.selectedSegmentIndex += 1
            self.tableView.reloadData()
        }
    }
    
    //MARK: updateSemesters
    func updateSemesters(){
        if (allMarks.Sems.count == 0){
            SemestrSegment.isHidden = true
            FalseSegment.isHidden = false
            
        }
        
        SemestrSegment.removeAllSegments()
        
        for sem in allMarks.Sems {
            let title = String(sem.number)
            SemestrSegment.insertSegment(withTitle: title, at: SemestrSegment.numberOfSegments, animated: false)
        }
        
        if (SemestrSegment.numberOfSegments > 0){
            UIView.animate(withDuration: 0.1, animations: {
                self.FalseSegment.isHidden = true
                self.SemestrSegment.isHidden = false
            })
        }
        
        if (allMarks.Sems.count != 0){
            for i in 0..<self.allMarks.Sems.count{
                var emptySemester = true
                //вводим эту переменную, чтобы решить баг в случае пустых семестров
                //emptySemester - есть ли оценки в этом семестре
                let howManyDisciplines = self.allMarks.Sems[i].Semestr.count
                if (howManyDisciplines == 0){
                    emptySemester = false
                } else {
                    for j in 0..<howManyDisciplines{
                        let subject = self.allMarks.Sems[i].Semestr[j]
                        let emptySubject = !(subject.FirstKn != nil || subject.SecondKn != nil || subject.Result != nil)
                        emptySemester = emptySubject && emptySemester
                    }
                }
                
                
                //если семестр ряльно без оценок, и предыдущий не пустой (в смысле в предыдущем вообще есть дисциплины), то ставим предыдущий
                //предыдущий ряльно без дисциплин, то ставим текущий даже без учета того, что оценок там особо-то и нет
                if (emptySemester == true){
                    var prevSemIsReallyEmpty = false
                    if (i != 0) {
                        prevSemIsReallyEmpty = self.allMarks.Sems[i-1].Semestr.count == 0
                        if (prevSemIsReallyEmpty){
                            self.SemestrSegment.selectedSegmentIndex = i
                        } else {self.SemestrSegment.selectedSegmentIndex = i - 1}
                    } else {
                        self.SemestrSegment.selectedSegmentIndex = 0
                    }
                    break
                } else if (i == self.allMarks.Sems.count - 1){
                    self.SemestrSegment.selectedSegmentIndex = i
                }
            }
        }
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    //MARK: numberOfRowsInection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (allMarks.Sems.count == 0){
            return 1
        } else {
            return allMarks.Sems[self.SemestrSegment.selectedSegmentIndex].Semestr.count
        }
    }

    //MARK: cellForRow
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (SemestrSegment.selectedSegmentIndex > allMarks.Sems.count - 1) || (allMarks.Sems.count == 0){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath) as? loadingCell else {
                fatalError()
            }
            return cell
        } else if (indexPath.row > allMarks.Sems[SemestrSegment.selectedSegmentIndex].Semestr.count - 1) {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MarkCell", for: indexPath) as? MarkCell else {
            fatalError()
        }
        
        let cellData = allMarks.Sems[self.SemestrSegment.selectedSegmentIndex].Semestr[indexPath.row]
        
        cell.FirstKn = cellData.FirstKn
        cell.SecondKn = cellData.SecondKn
        cell.Result = cellData.Result
        cell.PropFirstKn = cellData.PropFirstKn
        cell.PropSecondKn = cellData.PropSecondKn
        
        cell.result.alpha = 1
        cell.DisName.text = cellData.Name
        cell.typeName.text = cellData.ResType
        if (cellData.Result != nil){
            cell.result.text = cellData.Result
        } else {
            if (cellData.FirstKn != nil){
                cell.result.text = "1 кн: \(cellData.FirstKn!)"
            }
            if (cellData.SecondKn != nil){
                cell.result.text = "2 кн: \(cellData.SecondKn!)"
            }
            if (cellData.Result != nil){
                cell.result.text = cellData.Result
            }
            if (cellData.FirstKn == nil && cellData.SecondKn == nil && cellData.Result == nil){
                cell.result.text = "пусто"
                cell.result.alpha = 0.2
            }
        }
        return cell
    }
    
    //MARK: titleForHeaderInSection
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (allMarks.Sems.count != 1){
            return String(SemestrSegment.selectedSegmentIndex + 1) + " " + NSLocalizedString("семестр", comment: "")
        } else {return NSLocalizedString("Ошибка", comment: "")}
    }
    
    
    
    //MARK: - Средний балл
    //считаем средний балл ура
    func fillTheArrays(){
        if (allMarks.Sems.count > 0){
            AverageMarkItem.isEnabled = true
        } else {
            AverageMarkItem.isEnabled = false
        }
    }
    
    //MARK: makeADiploma
    func makeADiploma(_ marks: multipleSems) -> [String: Int]?{
        var howManyInSemester = [Int]()
        var subjectNames = [String]()
        var subjectMarks = [Float]()
        var i = 0
        
        for sem in marks.Sems {
            i += 1
            for mark in sem.Semestr {
                let intResult = Int(mark.Result ?? "") ?? 0
                if (intResult > 0){
                    if (subjectNames.contains(mark.Name)){
                        let index = subjectNames.firstIndex(of: mark.Name) ?? 0
                        howManyInSemester[index] += 1
                        subjectMarks[index] += Float(intResult)
                    } else {
                        howManyInSemester.append(1)
                        subjectNames.append(mark.Name)
                        subjectMarks.append(Float(intResult))
                    }
                }
            }
        }
        if (subjectMarks.count == 0) {return nil}
        
        var output = [String: Int]()
        for i in 0...subjectMarks.count - 1 {
            if (howManyInSemester[i] > 1){
                subjectMarks[i] = subjectMarks[i]/Float(howManyInSemester[i])
            }
            output[subjectNames[i]] = Int(round(subjectMarks[i]))
        }
        return output
    }
    
    
    //MARK: getAverageOverall
    func getAverageOverall(_ diploma: [String: Int]) -> Float{
        var howmany = 0
        var sum: Float = 0
        for (_, mark) in diploma {
            howmany += 1
            sum += Float(mark)
        }
        return round((sum/Float(howmany))*100)/100
    }
    
    //MARK: averagePerSem
    func averagePerSem(_ marks: multipleSems) -> [Float] {
        var i = 0
//        var output = [Int: Float]()
        var output = [Float]()
        for sem in marks.Sems {
            i += 1
            var semSum: Float = 0
            var howManySubj: Float = 0
            
            for mark in sem.Semestr {
                let intResult = Int(mark.Result ?? "") ?? 0
                if (intResult > 0){
                    semSum += Float(intResult)
                    howManySubj += 1
                }
            }
//            output[i] = round((semSum/howManySubj)*100)/100
            output.append(round((semSum/howManySubj)*100)/100)
        }
        return output
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
    
    //MARK: checkMarksConsistency
    func checkMarksConsistency(_ data: multipleSems) -> Bool {
        var prevSemNumber = 0
        var prevSemHasMarks = true
        for sem in data.Sems {
            if (prevSemNumber + 1 != sem.number) {return false}
            if !prevSemHasMarks && (sem.hasMarks()) {return false}
            
            prevSemNumber = sem.number
            prevSemHasMarks = sem.hasMarks()
        }
        return true
    }
    
    // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GoToSingleMark"){
            let cell = sender as! MarkCell
            let goToVC = segue.destination as! SingleMarkViewController
            goToVC.inputCell = cell
        } else if (segue.identifier == "AverageMark"){
            let goToVC = segue.destination as! AverageMarkTableViewController
            goToVC.diploma = makeADiploma(allMarks) ?? [String: Int]()
            goToVC.averageSems = averagePerSem(allMarks)
            goToVC.averageOverall = getAverageOverall(goToVC.diploma)
            goToVC.isDataConsistent = checkMarksConsistency(allMarks)
        }
                 // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
}
