//
//  MoreRoomsTableViewController.swift
//  nntu pre-alpha
//
//  Created by Алексей Шерстнёв on 05.08.2020.
//  Copyright © 2020 Алексей Шерстнев. All rights reserved.
//

import UIKit

struct room {
    let name : String
    let number : String
}

class building {
    var rooms = [room]()
    func addRoom(_ name: String, _ number: String){
        rooms.append(room(name: name, number: number))
    }
}

class MoreRoomsTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var SearchTextField: UITextField!
    @IBOutlet var BuildingSegment: UISegmentedControl!
    @IBOutlet var BuildingStack: UIStackView!
    
    
    let firstBuilding = building()
    let secondBuilding = building()
    let thirdBuilding = building()
    let fourthBuilding = building()
    let fifthBuilding = building()
    let sixthBuilding = building()
    
    var controllerData = building()
    
    var everyBuilding = [building]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstBuilding.addRoom("Эта часть навигации находится в работе", "1101")
        
        secondBuilding.addRoom("Директор библиотеки", "2306")
        secondBuilding.addRoom("Женский туалет", "2206")
        secondBuilding.addRoom("Зал электронных ресурсов", "2210")
        secondBuilding.addRoom("Информационно-библиографический отдел. Каталоги.", "2209")
        secondBuilding.addRoom("Компьютерный класс АГПМиСМ", "2102")
        secondBuilding.addRoom("Мужской туалет", "2105")
        secondBuilding.addRoom("Научно-методический отдел", "2301")
        secondBuilding.addRoom("Отдел автоматизации библиотечных ресурсов", "2305")
        secondBuilding.addRoom("Отдел комплектования", "2304")
        secondBuilding.addRoom("Отдел комплектования НТБ и зал технической обработки", "2107")
        secondBuilding.addRoom("Отдел обслуживания научной литературой. Читальный зал научной литературы", "2303")
        secondBuilding.addRoom("Отдел связи ИВЦ", "2101")
        secondBuilding.addRoom("Отдел учета и библиотечной обработки документов", "2201")
        secondBuilding.addRoom("Отдел учета и библиотечной обработки документов (второе помещение)", "2211")
        secondBuilding.addRoom("Президентская программа подготовки управленческих кадров (специальность \"Менеджмент\"); Администрация", "2205")
        secondBuilding.addRoom("Преподавательская кафедра АГПМиСМ", "2108")
        secondBuilding.addRoom("Преподавательская кафедра ТиОМ", "2308")
        secondBuilding.addRoom("Сектор анализа и прогнозирования деятельности НТБ", "2207")
        secondBuilding.addRoom("Учебная лаборатория \"Теория механизмов и прикладная механика\"", "2309")
        secondBuilding.addRoom("Учебная лаборатория АГПМиСМ", "2102")
        secondBuilding.addRoom("Учебная лаборатория дизельных двигателей", "2104")
        secondBuilding.addRoom("Учебная лаборатория метрологии, стандартизации, сертификации кафедры \"Машиностроительные технологические комплексы\"", "2207")
        secondBuilding.addRoom("Учебная лаборатория метрологии, стандартизации, сертификации кафедры \"Машиностроительные технологические комплексы\"", "2109")
        secondBuilding.addRoom("Учебная лаборатория нанотехнологий и машиностроения", "2103")
        secondBuilding.addRoom("Учебная лаборатория технологической оснастки", "2307")
        secondBuilding.addRoom("Ученая лаборатория гидро и пневмосистем", "2106")
        secondBuilding.addRoom("Хозяйственный отдел НТБ", "2204")
        secondBuilding.addRoom("Читальный зал", "2202")
        secondBuilding.addRoom("Электрощитовая ОГЭ", "2105")
        
        
        thirdBuilding.addRoom("Эта часть навигации находится в работе", "3101")
        
        fourthBuilding.addRoom("Эта часть навигации находится в работе", "4101")
        
        fifthBuilding.addRoom("Эта часть навигации находится в работе", "5101")
        
        sixthBuilding.addRoom("Библиотека: абонемент для студентов младших курсов", "6116")
        sixthBuilding.addRoom("Библиотека: абонемент для студентов старших курсов", "6270")
        sixthBuilding.addRoom("Архивохранилище (1 этаж)", "6100")
        sixthBuilding.addRoom("Архивохранилище (2 этаж)", "6234")
        sixthBuilding.addRoom("Дирекция ИНЭЛ", "6210")
        sixthBuilding.addRoom("Дирекция ИРИТ", "6211")
        sixthBuilding.addRoom("Дирекция ИТС", "6206")
        sixthBuilding.addRoom("Дирекция ИТС (второе помещение)", "6209")
        sixthBuilding.addRoom("Дом научной коллаборации (ДНК)", "6022")
        sixthBuilding.addRoom("Зал электронных ресурсов", "6119")
        sixthBuilding.addRoom("Заочное отделение кафедры «Связи с общественностью, маркетинга и коммуникации»", "6301")
        sixthBuilding.addRoom("Кабинет ведущего инженера службы главного инженера", "6226")
        sixthBuilding.addRoom("Кабинет группы сопровождения учебного процесса", "6344")
        sixthBuilding.addRoom("Кабинет директора ИВЦ, начальника управления информатизации", "6337")
        sixthBuilding.addRoom("Кабинет зав. кафедрой «Графические информационные системы»", "6446")
        sixthBuilding.addRoom("Кабинет зав. кафедрой «Инженерная графика»", "6551")
        sixthBuilding.addRoom("Кабинет зав. кафедрой «Общая и ядерная физика»", "6248")
        sixthBuilding.addRoom("Кабинет зав. кафедрой «Проектирование и эксплуатация газонефтепроводов и газонефтехранилищ", "6458")
        sixthBuilding.addRoom("Кабинет зав. кафедрой «Производственная безопасность, экология и химия»", "6262")
        sixthBuilding.addRoom("Кабинет зав. кафедрой \"Высшая математика\"", "6202")
        sixthBuilding.addRoom("Кабинет зав. лабораторией БЖД", "6348")
        sixthBuilding.addRoom("Кабинет заместителя начальника отдела обеспечения безопасности", "6203")
        sixthBuilding.addRoom("Кабинет коменданта 6 корпуса", "6223")
        sixthBuilding.addRoom("Кабинет начальника 2 отдела", "6207")
        sixthBuilding.addRoom("Кабинет помощника ректора по 6 корпусу", "6212")
        sixthBuilding.addRoom("Кабинет помощника ректора по безопасности", "6216")
        sixthBuilding.addRoom("Кабинет сотрудников архива", "6230")
        sixthBuilding.addRoom("Кафедра «Графические информационные системы»", "6451")
        sixthBuilding.addRoom("Компьютерный класс БЖД", "6346")
        sixthBuilding.addRoom("Лаборатория «Оптика»", "6257")
        sixthBuilding.addRoom("Лаборатория «Физико-химических методов анализа»", "6260")
        sixthBuilding.addRoom("Лаборатория ИНЭУ", "6215")
        sixthBuilding.addRoom("Лаборатория кафедры «Электроэнергетика, электроснабжение и силовая электроника»", "6440")
        sixthBuilding.addRoom("Лаборатория социологических исследований", "6303")
        sixthBuilding.addRoom("Лаборатория эксплуатации надежности метариалов ", "6353")
        sixthBuilding.addRoom("Лабораторный зал", "6264")
        sixthBuilding.addRoom("Лабораторный класс", "6261")
        sixthBuilding.addRoom("Медицинский кабинет", "6103")
        sixthBuilding.addRoom("Методический кабинет кафедры «Иностранные языки»", "6405")
        sixthBuilding.addRoom("Методический кабинет кафедры «Прикладная математика»", "6227")
        sixthBuilding.addRoom("Научно-исследовательская экоаналитическая лаборатория", "6355")
        sixthBuilding.addRoom("Научно-техническая библиотека", "6199")
        sixthBuilding.addRoom("Отдел по работе со студентами", "6225")
        sixthBuilding.addRoom("Помещение воинского учета студентов и работников НГТУ", "6233")
        sixthBuilding.addRoom("Помещение кафедра «Проектирование и эксплуатация газонефтепроводов и газонефтехранилищ»", "6459")
        sixthBuilding.addRoom("Помещение кафедры «Инженерная графика»", "6559")
        sixthBuilding.addRoom("Помещение кафедры «Иностранные языки»", "6404")
        sixthBuilding.addRoom("Помещение кафедры «Методология, история и философия науки»", "6402")
        sixthBuilding.addRoom("Помещение кафедры «Общая и ядерная физика»", "6247")
        sixthBuilding.addRoom("Помещение кафедры «Связи с общественностью, маркетинга и коммуникации»", "6300")
        sixthBuilding.addRoom("Помещение кафедры \"Высшая математика\"", "6201")
        sixthBuilding.addRoom("Помещение кафедры \"Физическое воспитание\"", "6020")
        sixthBuilding.addRoom("Помещение преподавателей дисциплины БЖД", "6352")
        sixthBuilding.addRoom("Помещение преподавателей дисциплины экология", "6349")
        sixthBuilding.addRoom("Помещение ШОПОМ", "6208")
        sixthBuilding.addRoom("Помещения Центра системных технологий открытого образования", "6543")
        sixthBuilding.addRoom("Помощник ректора", "6220")
        sixthBuilding.addRoom("Приемная ректора и проректоров в 6 учебном корпусе", "6218")
        sixthBuilding.addRoom("Профсоюзный комитет студентов НГТУ", "6315")
        sixthBuilding.addRoom("Региональный центр просветительства, культурного и исторического наследия", "6401")
        sixthBuilding.addRoom("Спортивный комплекс", "6111")
        sixthBuilding.addRoom("Столовая", "6114")
        sixthBuilding.addRoom("Учебная аудитория «Центра обучения иностранных студентов»", "6462")
        sixthBuilding.addRoom("Учебная часть ИНЭУ", "6205")
        sixthBuilding.addRoom("Учебный отдел", "6221")
        sixthBuilding.addRoom("Читальный зал", "6162")
        
        everyBuilding = [firstBuilding, secondBuilding, thirdBuilding, fourthBuilding, fifthBuilding, sixthBuilding]

        let parentController = ControllerToUpdate as! NavigationViewController
        BuildingSegment.selectedSegmentIndex = parentController.choosingBuilding.selectedSegmentIndex
        
        let config = UIImage.SymbolConfiguration(textStyle: .body)
        let glassImage = UIImageView()
        glassImage.bounds = view.frame.insetBy(dx: -20,dy: 0)
        glassImage.image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        SearchTextField.leftView = glassImage
        SearchTextField.leftViewMode = .always
        SearchTextField.delegate = self
        
        reloadDataWithSegment()

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
        return controllerData.rooms.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(BuildingSegment.selectedSegmentIndex + 1) корпус"
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "roomCell", for: indexPath) as? RoomCell else {
            fatalError()
        }
        cell.roomName.text = controllerData.rooms[indexPath.row].name
        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PreLoadedRoom = self.controllerData.rooms[indexPath.row].number
        ControllerToUpdate?.viewDidAppear(true)
        self.dismiss(animated: true, completion: {
        })
    }
    
    func reloadDataWithSegment(){
        controllerData = everyBuilding[BuildingSegment.selectedSegmentIndex]
        self.tableView.reloadData()
    }
    
    @IBAction func SegmentChanged(_ sender: Any) {
        reloadDataWithSegment()
    }
    
    @IBAction func SearchStarted(_ sender: Any) {
        UIView.animate(withDuration: 0.25, animations: {
            self.BuildingStack.isHidden = true
        })
        UIView.animate(withDuration: 0.15, animations: {
            self.BuildingStack.alpha = 0
        })
    }
    
    @IBAction func TapHappened(_ sender: Any) {
        SearchTextField.endEditing(true)
    }
    
    @IBAction func SearchEnded(_ sender: Any) {
        UIView.animate(withDuration: 0.15, animations: {
            self.BuildingStack.isHidden = false
        })
        UIView.animate(withDuration: 0.4, animations: {
            self.BuildingStack.alpha = 1
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SearchTextField.endEditing(true)
        return false
    }
    
    
    @IBAction func SearchWhileTyping(_ sender: Any) {
        controllerData = everyBuilding[BuildingSegment.selectedSegmentIndex]
        if (SearchTextField.text != "" && SearchTextField.text != nil){
            controllerData = search(controllerData, SearchTextField.text ?? "")
        }
        self.tableView.reloadData()
    }
    
    func search(_ input: building, _ searchWord: String) -> building{
        var output = building()
        for i in 0...input.rooms.count - 1{
            if (input.rooms[i].name.capitalize().contains(searchWord.capitalize())){
                output.rooms.append(input.rooms[i])
            } else if (input.rooms[i].number.capitalize().contains(searchWord.capitalize())){
                output.rooms.append(input.rooms[i])
            }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
