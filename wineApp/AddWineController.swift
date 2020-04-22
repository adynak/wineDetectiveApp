import UIKit

let PADDING: CGFloat = 12.0

class AddWineController: UIViewController {
    
    let cellID = "cellid"
    let tableContainerTopAnchor:CGFloat = 200.0
    let tableContainerHeightAnchor:CGFloat = 230.0
    let tableRowHeight:CGFloat = 50
    
    var cells = [AddTableViewCell]() //initialize array at class level
    
    var passedValue = wineDetail()
    
    let binNames = ["A","B"]
    
    var vintages = [2016, 2015, 2014]
    var vintagePicker = UIPickerView()
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let doneButton = UIBarButtonItem(title: "Done",
                                     style: UIBarButtonItem.Style.plain,
                                     target: self,
                                     action: #selector(donePicker))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
                                      target: nil,
                                      action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel",
                                       style: UIBarButtonItem.Style.plain,
                                       target: self,
                                       action: #selector(donePicker))
    
    let pickerToolbar: UIToolbar = {
        let tb = UIToolbar()
        tb.barStyle = UIBarStyle.default
        tb.isTranslucent = true
        tb.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        tb.sizeToFit()
        tb.isUserInteractionEnabled = true
        return tb
    }()
    
    var vintagePickerFielr: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Vintage"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let vintageSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let producerTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Producer"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let producerSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let varietalTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Varietal"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let varietalSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let designationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Designation"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let designationSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let avaTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "AVA"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let avaSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let storageLabel: UITextView = {
        let tv = UITextView()
        tv.text = "Cellar Locations:\n"
        tv.font = UIFont.boldSystemFont(ofSize: 14)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor(r:202, g:227, b:255)
        tv.textAlignment = .left
        tv.isEditable = false
        tv.isScrollEnabled = true
        return tv
    }()
    
    let tableContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 5
        return v
    }()
    
    let wineBinsTableView : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.cornerRadius = 5
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        view.backgroundColor = UIColor(r:202, g:227, b:255)

        
        setupVintagePicker()
        
        vintagePickerFielr.inputView = vintagePicker
        vintagePickerFielr.inputAccessoryView = setupVintagePickerToolbar()
        
        vintagePickerFielr.delegate = self
        producerTextField.delegate = self
        varietalTextField.delegate = self
        designationTextField.delegate = self
        avaTextField.delegate = self
        
        view.addSubview(inputsContainerView)
        view.addSubview(storageLabel)
        view.addSubview(tableContainer)
        tableContainer.addSubview(wineBinsTableView)
        
        setupNavigationBar()
        setupInputsContainerView()
        setupWineBinsTableViewLayout()
        
        assignPassedValuesToTextarea()
        vintagePickerFielr.becomeFirstResponder()
        
    }
    
    func setupVintagePicker(){
        let date = Date()
        let calendar = Calendar.current
        
        // look back 20 years
        let year = calendar.component(.year, from: date)
        let result = (year-20...year).map { $0 * 1 }
        vintages = result.reversed()
        
        vintagePicker.delegate = self
        vintagePicker.dataSource = self
        // default picker to 4th row
        vintagePicker.selectRow(3, inComponent: 0, animated: true)
        vintagePicker.heightAnchor.constraint(equalToConstant: 250).isActive = true

    }
    
    func setupVintagePickerToolbar()-> UIToolbar{

        let toolBarLabel = UILabel.init(frame: (CGRect.init(origin: CGPoint.init(x: 0.0, y: 0.0), size: CGSize.init(width: 0.0, height: 0.0))))

        toolBarLabel.text = "Vintages"
        toolBarLabel.sizeToFit()
        toolBarLabel.backgroundColor = .clear
        toolBarLabel.textColor = .white
        toolBarLabel.textAlignment = .center
        toolBarLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)

        
        let labelItem = UIBarButtonItem.init(customView: toolBarLabel)
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target:nil, action:nil)
        
        let vintageToolbar = pickerToolbar
        vintageToolbar.barTintColor = .green
        vintageToolbar.layer.cornerRadius = 5
        vintageToolbar.translatesAutoresizingMaskIntoConstraints = false

        vintageToolbar.widthAnchor.constraint(equalToConstant: 100.0).isActive = true

        vintageToolbar.setItems([cancelButton, flexible, labelItem, flexible, doneButton], animated: false)
        
        return vintageToolbar

        
    }
    
    func assignPassedValuesToTextarea(){
        if (passedValue.storageBins?.count != nil){
            
            navigationItem.title = "More of These"

            vintagePickerFielr.text = passedValue.vintage
            varietalTextField.text = passedValue.varietal
            producerTextField.text = passedValue.producer
            designationTextField.text = passedValue.designation
            avaTextField.text = passedValue.ava
            // disable changing these fields
            vintagePickerFielr.isUserInteractionEnabled = false
            varietalTextField.isUserInteractionEnabled = false
            producerTextField.isUserInteractionEnabled = false
            designationTextField.isUserInteractionEnabled = false
            avaTextField.isUserInteractionEnabled = false

        }
    }
    
    private func setupNavigationBar(){
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Add Wine"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(addTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addTapped))
    }
    
    @objc func addTapped(sender: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func donePicker(sender: UIBarButtonItem){
        if (sender.title == "Done"){
            let row = vintagePicker.selectedRow(inComponent: 0)
            vintagePickerFielr.text = String(vintages[row])
        }
        producerTextField.becomeFirstResponder()
    }
    
    func setupInputsContainerView() {
        
        NSLayoutConstraint.activate([
            inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputsContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            inputsContainerView.heightAnchor.constraint(equalToConstant: 200),
            inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24)
        ])

        inputsContainerView.addSubview(vintagePickerFielr)
        inputsContainerView.addSubview(vintageSeparatorView)
        inputsContainerView.addSubview(producerTextField)
        inputsContainerView.addSubview(producerSeparatorView)
        inputsContainerView.addSubview(varietalTextField)
        inputsContainerView.addSubview(varietalSeparatorView)
        inputsContainerView.addSubview(designationTextField)
        inputsContainerView.addSubview(designationSeparatorView)
        inputsContainerView.addSubview(avaTextField)
        
        NSLayoutConstraint.activate([
            vintagePickerFielr.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: PADDING),
            vintagePickerFielr.topAnchor.constraint(equalTo: inputsContainerView.topAnchor),
            vintagePickerFielr.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            vintagePickerFielr.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5),
            
            vintageSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor),
            vintageSeparatorView.topAnchor.constraint(equalTo: vintagePickerFielr.bottomAnchor),
            vintageSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            vintageSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            
            producerTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: PADDING),
            producerTextField.topAnchor.constraint(equalTo: vintageSeparatorView.topAnchor),
            producerTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            producerTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5),
            
            producerSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor),
            producerSeparatorView.topAnchor.constraint(equalTo: producerTextField.bottomAnchor),
            producerSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            producerSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            
            varietalTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: PADDING),
            varietalTextField.topAnchor.constraint(equalTo: producerSeparatorView.topAnchor),
            varietalTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            varietalTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5),
            
            varietalSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor),
            varietalSeparatorView.topAnchor.constraint(equalTo: varietalTextField.bottomAnchor),
            varietalSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            varietalSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            
            designationTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: PADDING),
            designationTextField.topAnchor.constraint(equalTo: varietalSeparatorView.topAnchor),
            designationTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            designationTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5),
            
            designationSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor),
            designationSeparatorView.topAnchor.constraint(equalTo: designationTextField.bottomAnchor),
            designationSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            designationSeparatorView.heightAnchor.constraint(equalToConstant: 1),
            
            avaTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: PADDING),
            avaTextField.topAnchor.constraint(equalTo: designationSeparatorView.topAnchor),
            avaTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor),
            avaTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/5)

        ])
        
        
    }

    func setupWineBinsTableViewLayout(){
        
        NSLayoutConstraint.activate([
            storageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            storageLabel.topAnchor.constraint(equalTo: avaTextField.bottomAnchor, constant : 11.0),
            storageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24),
            storageLabel.heightAnchor.constraint(equalToConstant: 22)
        ])

        
        tableContainer.backgroundColor = .white
        NSLayoutConstraint.activate([
            tableContainer.topAnchor.constraint(equalTo:storageLabel.bottomAnchor, constant:10),
            tableContainer.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor, constant : PADDING),
            tableContainer.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant : -PADDING),
            tableContainer.heightAnchor.constraint(equalToConstant: tableContainerHeightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            wineBinsTableView.topAnchor.constraint(equalTo:tableContainer.topAnchor, constant: 5),
            wineBinsTableView.leadingAnchor.constraint(equalTo:tableContainer.leadingAnchor, constant: 5),
            wineBinsTableView.trailingAnchor.constraint(equalTo:tableContainer.trailingAnchor, constant: -5),
            wineBinsTableView.bottomAnchor.constraint(equalTo:tableContainer.bottomAnchor, constant: -5)
        ])
        
        wineBinsTableView.dataSource = self
        wineBinsTableView.register(AddTableViewCell.self, forCellReuseIdentifier: cellID)
        wineBinsTableView.rowHeight = tableRowHeight

        
    }
    
}

extension AddWineController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        switch textField {
        case vintagePickerFielr:
            producerTextField.becomeFirstResponder()
        case producerTextField:
            varietalTextField.becomeFirstResponder()
        case varietalTextField:
            designationTextField.becomeFirstResponder()
        case designationTextField:
            avaTextField.becomeFirstResponder()
        case avaTextField:
            vintagePickerFielr.becomeFirstResponder()
        default:
            textField.becomeFirstResponder()
        }
        
        return true
    }
}


extension AddWineController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
}
extension AddWineController: UITableViewDataSource{
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("selected")
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AddTableViewCell
        cell.bin = binNames[indexPath.row]
        
        if(!cells.contains(cell)){
            self.cells.append(cell)
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let accept = UIContextualAction(style: .normal, title: "Accept") { (action, view, nil) in
//            print("accept")
//        }
//        return UISwipeActionsConfiguration(actions: [accept])
//    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let contextItem = UIContextualAction(style: .normal, title: "Leading & .normal") { (contextualAction, view, boolValue) in
    boolValue(true) // pass true if you want the handler to allow the action
    print("Leading Action style .normal")
    }
    let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
    
    return swipeActions
    }
    

    
}

extension AddWineController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vintages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        vintageTextField.text = String(vintages[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(vintages[row])
    }
}
