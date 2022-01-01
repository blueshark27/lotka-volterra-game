//
//  GameLogic.swift
//  LV Game
//
//  Created by Steffen Hauth on 01.09.21.
//

import Foundation

protocol GameLogicDelegate {
    func update(idx: Int, value: Player)
    func diceResult(w1: Int, w2: Int, value: Player, currentTurn: Player)
}

enum Player
{
    case Prey
    case Predator
    case empty
}

class GameLogic
{
    var rows: Int
    var colums: Int
    var numStartingFields: Int
    var delegate: GameLogicDelegate
    var fieldCollection: [Player]
    var currentTurn: Player
    
    init(rows: Int, columns: Int, numStartingFields: Int, startingPlayer: Player, delegate: GameLogicDelegate)
    {
        self.rows = rows
        self.colums = columns
        self.numStartingFields = numStartingFields
        self.delegate = delegate
        self.fieldCollection = [Player](repeating: Player.empty, count: self.rows*self.colums) // 0 -> w -- 1 -> g -- 2 -> r
        self.currentTurn = startingPlayer
    }
    
    func initialValues()
    {
        let numFields = self.rows*self.colums
        for idx in randArr(self.numStartingFields, numFields-1)
        {
            if Bool.random()
            {
                self.fieldCollection[idx] = Player.Prey
                self.delegate.update(idx: idx, value: Player.Prey)
            }
            else
            {
                self.fieldCollection[idx] = Player.Predator
                self.delegate.update(idx: idx, value: Player.Predator)
            }
        }
    }
    
    func doRollingDice()
    {
        let w1 = Int.random(in: 0..<6)
        let w2 = Int.random(in: 0..<6)
        
        let idx = w1 * self.colums + w2
        
        assert(idx < self.fieldCollection.count)
        let val = self.fieldCollection[idx]
        
        self.delegate.diceResult(w1: w1, w2: w2, value: val, currentTurn: self.currentTurn)
        
        switch self.currentTurn
        {
        case Player.Predator:
            let currentTurnString = "Predator"
            switch val
            {
            case Player.empty:
                // do nothing
                NSLog("w1: \(w1+1) - w2: \(w2+1) - val: \(val) - turn: \(currentTurnString) --> Field is empty. Nothing happens.")
            case Player.Prey:
                NSLog("w1: \(w1+1) - w2: \(w2+1) - val: \(val) - turn: \(currentTurnString) --> Prey is on the field. Replaced by predator.")
                self.delegate.update(idx: idx, value: Player.Predator)
            case Player.Predator:
                // do nothing
                NSLog("w1: \(w1+1) - w2: \(w2+1) - val: \(val) - turn: \(currentTurnString) --> Predator is on the field.Nothing happens.")
            }

            self.currentTurn = Player.Prey

        case Player.Prey:
            let currentTurnString = "Prey"
            switch val
            {
            case Player.empty:
                NSLog("w1: \(w1+1) - w2: \(w2+1) - val: \(val) - turn: \(currentTurnString) --> Field is empty. Prey is set on that field.")
                self.delegate.update(idx: idx, value: Player.Prey)
            case Player.Prey:
                NSLog("w1: \(w1+1) - w2: \(w2+1) - val: \(val) - turn: \(currentTurnString) --> Field occupied by Prey. Checking neighboring fields.")
                let start1 = max(0, w1-1)
                let end1 = min(self.rows - 1, w1 + 1)
                let start2 = max(0, w2-1)
                let end2 = min(self.colums - 1, w2 + 1)
                outerLoop: for r in start1...end1
                {
                    for c in start2...end2
                    {
                        let i = r * self.colums + c
                        assert(i < self.fieldCollection.count)
                        let v = self.fieldCollection[i]
                        NSLog("checking r: \(r+1) - c: \(c+1) - v: \(v)")
                        if v == Player.empty
                        {
                            NSLog("field is empty -> putting prey on it")
                            self.fieldCollection[i] = Player.Prey
                            self.delegate.update(idx: i, value: Player.Prey)
                            break outerLoop
                        }
                    }
                }
            case Player.Predator:
                // do nothing
                NSLog("w1: \(w1+1) - w2: \(w2+1) - val: \(val) - turn: \(currentTurnString) --> Field is occupied by predator. Nothing happens.")
            }

            self.currentTurn = Player.Predator
        default:
            assert(false, "Default case should not be reached")
        }
    }
    
    private func randArr(_ elements: Int, _ max: Int) -> [Int]
    {
        return (0..<elements).map{ _ in Int.random(in: 0...max) }
    }
}
