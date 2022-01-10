//
//  OptionsConfiguration.swift
//  LV Game
//
//  Created by Steffen Hauth on 02.01.22.
//

import Foundation

enum OptionType {
    case Textfied
    case Switch
    case Integer
}

protocol OptionsValues {
}

struct OptionsValuesInteger : OptionsValues {
    var startValue: Int;
    var endValue: Int;
    var initValue: Int;
}

struct OptionsValuesTextfield : OptionsValues {
    var initValue: String;
}

struct OptionsValuesSwitch : OptionsValues {
    var initValue: Bool;
}


struct OptionsEntry {
    var label: String;
    var type: OptionType;
    var value: OptionsValues;
}

struct OptionsEntryGroup {
    var label: String
    var entries: [OptionsEntry]
}

class OptionsConfiguration {
    static let shared = OptionsConfiguration()
    
    let gameOptions: [OptionsEntryGroup]

    private init() {
        self.gameOptions = [OptionsEntryGroup(label: "Player configuration",
                                             entries: [OptionsEntry(label:"Playername",
                                                                    type:OptionType.Textfied,
                                                                    value:OptionsValuesTextfield(initValue: "Playername"))]),
                           OptionsEntryGroup(label: "Multiplayer configuration",
                                             entries: [OptionsEntry(label:"Multiplayer",
                                                                    type:OptionType.Switch,
                                                                    value:OptionsValuesSwitch(initValue: false))]),
                           OptionsEntryGroup(label: "Game configuration",
                                             entries: [OptionsEntry(label:"Field width",
                                                                    type:OptionType.Integer,
                                                                    value: OptionsValuesInteger(startValue: 2, endValue: 12, initValue: 6)),
                                                       OptionsEntry(label:"Field height",
                                                                    type:OptionType.Integer,
                                                                    value: OptionsValuesInteger(startValue: 2, endValue: 12, initValue: 6))])]
        
        // setting userdefaults
        let defaults = UserDefaults.standard
        for gameOptionGroup in self.gameOptions {
            for optionEntry in gameOptionGroup.entries {
                switch optionEntry.type {
                case OptionType.Textfied:
                    if defaults.string(forKey: optionEntry.label) == "" {
                        defaults.set((optionEntry.value as! OptionsValuesTextfield).initValue, forKey: optionEntry.label)
                    }
                case OptionType.Switch:
                    if !defaults.bool(forKey: optionEntry.label) {
                        defaults.set((optionEntry.value as! OptionsValuesSwitch).initValue, forKey: optionEntry.label)
                    }
                case OptionType.Integer:
                    if defaults.integer(forKey: optionEntry.label) == 0 {
                        defaults.set((optionEntry.value as! OptionsValuesInteger).initValue, forKey: optionEntry.label)
                    }
                }
            }
        }
    }
}
