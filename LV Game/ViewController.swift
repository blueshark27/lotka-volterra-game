//
//  ViewController.swift
//  LV Game
//
//  Created by Steffen Hauth on 17.08.21.
//

import UIKit

class ViewController: UIViewController, GameLogicDelegate
{
    @IBOutlet weak var buttonNext: UIBarButtonItem!
    var buttonCollection = [UIButton]()
    var buttonStatus = UIButton()
    
    let rows = 6
    let columns = 6
    let numStartFields = 15
    
    var gameLogic: GameLogic?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        debugPrint(self.view!.bounds.width)
        debugPrint(self.view!.bounds.height)
        
        makeCheckboardButtons(rows: rows, columns: columns, totalWidth: Int(self.view!.bounds.width), totalHeight: Int(self.view!.bounds.height), showIndex: true)
        
        gameLogic = GameLogic(rows: self.rows, columns: self.columns, numStartingFields: self.numStartFields, startingPlayer: Player.Prey, delegate: self)
        gameLogic?.initialValues()
    }
    
    func makeCheckboardButtons(rows: Int, columns: Int, totalWidth: Int, totalHeight: Int, showIndex: Bool)
    {
        let buttonWidth = totalWidth / (columns + 1)
        let offsetTop = 100
        
        buttonStatus = UIButton(frame: CGRect(x: 0, y: 50, width: totalWidth, height: buttonWidth))
        buttonStatus.setAttributedTitle(NSMutableAttributedString(string: String("W1: W2:")), for: .normal)
        buttonStatus.setTitleColor(UIColor.black, for: .normal)
        buttonStatus.backgroundColor = UIColor.white
        buttonStatus.layer.cornerRadius = 4
        view.addSubview(buttonStatus)

        var _rows = rows
        var _columns = columns
        if showIndex
        {
            _rows += 1
            _columns += 1
        }
        for row in 0..<_rows
        {
            for column in 0..<_columns
            {
                if showIndex && row == 0
                {
                    let button = UIButton(frame: CGRect(x: buttonWidth*column, y: buttonWidth*row + offsetTop, width: buttonWidth, height: buttonWidth))
                    button.backgroundColor = UIColor.white
                    button.setTitleColor(UIColor.black, for: .normal)
                    button.layer.cornerRadius = 4
                    button.restorationIdentifier = "index_\(column)_\(row)"
                    if column > 0
                    {
                        button.setAttributedTitle(NSMutableAttributedString(string: String(column)), for: .normal)
                    }
                    view.addSubview(button)
                }
                else if showIndex && column == 0
                {
                    let button = UIButton(frame: CGRect(x: buttonWidth*column, y: buttonWidth*row + offsetTop, width: buttonWidth, height: buttonWidth))
                    button.backgroundColor = UIColor.white
                    button.setTitleColor(UIColor.black, for: .normal)
                    button.layer.cornerRadius = 4
                    button.restorationIdentifier = "index_\(column)_\(row)"
                    if row > 0
                    {
                        button.setAttributedTitle(NSMutableAttributedString(string: String(row)), for: .normal)
                    }
                    view.addSubview(button)
                }
                else
                {
                    let button = UIButton(frame: CGRect(x: buttonWidth*column, y: buttonWidth*row + offsetTop, width: buttonWidth, height: buttonWidth))
                    button.backgroundColor = UIColor.white
                    button.setTitleColor(UIColor.black, for: .normal)
                    button.layer.cornerRadius = 4
                    if showIndex
                    {
                        button.restorationIdentifier = "field_\((row-1)*columns + column-1)"
                        button.setAttributedTitle(NSMutableAttributedString(string: String((row-1)*columns + column-1)), for: .normal)
                    }
                    else
                    {
                        button.restorationIdentifier = "field_\(row*columns+column)"
                        button.setAttributedTitle(NSMutableAttributedString(string: String(row*columns+column)), for: .normal)
                        
                    }
                    view.addSubview(button)
                    buttonCollection.append(button)
                }
            }
        }
    }

    func update(idx: Int, value: Player)
    {
        debugPrint("idx: \(idx) - value: \(value)")
        switch value
        {
        case Player.empty:
            buttonCollection[idx].backgroundColor = UIColor.white
            buttonCollection[idx].setAttributedTitle(NSMutableAttributedString(string: String(idx)), for: .normal)
        case Player.Prey:
            buttonCollection[idx].backgroundColor = UIColor.green
            buttonCollection[idx].setAttributedTitle(NSMutableAttributedString(string: String(idx)), for: .normal)
        case Player.Predator:
            buttonCollection[idx].backgroundColor = UIColor.red
            buttonCollection[idx].setAttributedTitle(NSMutableAttributedString(string: String(idx)), for: .normal)
        }
    }
    
    func diceResult(w1: Int, w2: Int, value: Player, currentTurn: Player)
    {
        let valString = (value == Player.Predator) ? "Predator" : "Prey"
        let turnString = (currentTurn == Player.Predator) ? "Predator" : "Prey"
        buttonStatus.setAttributedTitle(NSMutableAttributedString(string: String("D1: \(w1) - D2: \(w2) - val: \(valString) - turn: \(turnString)")), for: .normal)
    }
    
    @IBAction func onButtonNext(sender: UIBarButtonItem, forEvent event: UIEvent)
    {
        gameLogic?.doRollingDice()
    }
}
