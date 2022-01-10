//
//  TestTableViewController.swift
//  LV Game
//
//  Created by Steffen Hauth on 02.01.22.
//

import UIKit

class OptionsTableViewController: UITableViewController
{   
    let gameOptions = OptionsConfiguration.shared.gameOptions
    let defaults = UserDefaults.standard
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.title = "Options"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return gameOptions.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameOptions[section].entries.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return gameOptions[section].label
    }
       
    override func tableView(_ tableView: UITableView,
                             cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Mit dequeueReusableCell werden Zellen gemäß der im Storyboard definierten Prototypen erzeugt
        let cell = tableView.dequeueReusableCell(withIdentifier:"OptionsCell", for: indexPath)
        let userDefaultsLabel = gameOptions[indexPath.section].entries[indexPath.row].label
        
        switch gameOptions[indexPath.section].entries[indexPath.row].type {
        case OptionType.Textfied:
            let txtField: UITextField = CustomUITextField(userDefaultsLabel: gameOptions[indexPath.section].entries[indexPath.row].label, frame: CGRect(x: 0, y: 0, width: 230, height: 35));
            txtField.translatesAutoresizingMaskIntoConstraints = false
            txtField.borderStyle = UITextField.BorderStyle.roundedRect
            txtField.autocorrectionType = UITextAutocorrectionType.no
            txtField.keyboardType = UIKeyboardType.default
            txtField.returnKeyType = UIReturnKeyType.done
            txtField.clearButtonMode = UITextField.ViewMode.whileEditing
            txtField.delegate = (txtField as! UITextFieldDelegate)
            if defaults.string(forKey: userDefaultsLabel) == "" {
                txtField.placeholder = gameOptions[indexPath.section].entries[indexPath.row].label
            } else {
                txtField.text = defaults.string(forKey: userDefaultsLabel)
            }
            cell.accessoryView = txtField
        case OptionType.Switch:
            let switchView = CustomUISwitch(userDefaultsLabel: userDefaultsLabel, frame: .zero)
            switchView.tag = indexPath.row
            cell.accessoryView = switchView
        case OptionType.Integer:
            let goInteger = gameOptions[indexPath.section].entries[indexPath.row].value as! OptionsValuesInteger
            let startValue = goInteger.startValue
            let endValue = goInteger.endValue
            let initValue = defaults.integer(forKey: userDefaultsLabel)
            let pickerData = Array(startValue...endValue)
            let pickerView = CustomPickerView(pickerData: pickerData, userDefaultsLabel: userDefaultsLabel, frame: CGRect(x: 0, y: 0, width: 150, height: 50))
            pickerView.delegate = pickerView
            pickerView.dataSource = pickerView
            if let indexPosition = pickerData.firstIndex(of: initValue){
                pickerView.selectRow(indexPosition, inComponent: 0, animated: true)
            }
            cell.accessoryView = pickerView
        }
        
        // Zelle konfigurieren
        cell.textLabel?.text = gameOptions[indexPath.section].entries[indexPath.row].label

        return cell
    }
}

class CustomUITextField : UITextField, UITextFieldDelegate {
    var userDefaultsLabel: String
    let defaults = UserDefaults.standard

    init(userDefaultsLabel: String, frame: CGRect) {
        self.userDefaultsLabel = userDefaultsLabel
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        self.defaults.set(self.text, forKey: self.userDefaultsLabel)
        
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        self.defaults.set(self.text, forKey: self.userDefaultsLabel)
‚        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
        self.defaults.set(self.text, forKey: self.userDefaultsLabel)
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        textField.resignFirstResponder()
        // may be useful: textField.resignFirstResponder()
        return true
    }
}

class CustomUISwitch : UISwitch {
    var userDefaultsLabel: String
    let defaults = UserDefaults.standard

    init(userDefaultsLabel: String, frame: CGRect) {
        self.userDefaultsLabel = userDefaultsLabel
        super.init(frame: frame)
        self.addTarget(self, action: #selector(self.switchStateDidChange(_:)), for: .valueChanged)
        self.setOn(self.defaults.bool(forKey: self.userDefaultsLabel), animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func switchStateDidChange(_ sender:UISwitch!)
    {
        if (sender.isOn == true){
            self.defaults.set(true, forKey: userDefaultsLabel)
        }
        else{
            self.defaults.set(false, forKey: userDefaultsLabel)
        }
    }
}

class CustomPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    var pickerData: Array<Any>
    var selectedValue: Any
    var userDefaultsLabel: String
    let defaults = UserDefaults.standard

    init(pickerData: Array<Any>, userDefaultsLabel: String, frame: CGRect) {
        self.pickerData = pickerData
        self.selectedValue = self.pickerData[0]
        self.userDefaultsLabel = userDefaultsLabel
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: self.pickerData[row])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedValue = self.pickerData[row]
        defaults.set(self.selectedValue, forKey: self.userDefaultsLabel)
    }
    
    override func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
        self.selectedValue = self.pickerData[row]
        super.selectRow(row, inComponent: component, animated: animated)
        defaults.set(self.selectedValue, forKey: self.userDefaultsLabel)
    }
    
    func getSelectedValue() -> Any {
        return self.selectedValue
    }
}
