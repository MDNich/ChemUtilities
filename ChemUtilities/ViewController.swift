//
//  ViewController.swift
//  ChemUtilities
//
//  Created by שמים זורעי כוכבים on 7/16/24.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var eqField: NSTextField!
    
    @IBOutlet weak var eqType: NSSegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func Balance(_ sender: Any) {
        
        var input = "NO2(-) + "
        
        // MARK: Parse Equation
        
        
        // MARK: Balance Equation
        
        // MARK: Calculate Stoichiometry
        
        // MARK: Calculate Enthalpy, Entropy, Gibbs, and Spontaneity
        
        // MARK: Acid Base Titration Calculations (only if AcidBase)
        
        
    }
    
    

    
}

// MARK: Elements Classes

enum e {
    case _1s
    case _2s
    case _2p
    case _3s
    case _3d
    case _3p
    case _4s
    case _4p
    case _4d
    case _4f
    case _5s
    case _5p
    case _5d
    case _5f
    case _6s
    case _6p
    case _6d
    case _6f
}

enum elementType {
    case hydrogen
    case nobleGas
    case nonmetal
    case metal
    case transitionMetal
    case metalloid
    case lanthanide
    case actinide
}

class ElectronShell {
    var shells: [e]
    var numEperShell: [Int]
    
    init(shells: [e], numEperShell: [Int]) {
        self.shells = shells
        self.numEperShell = numEperShell
    }
}

protocol Element {
    var str: String { get }
    var Z: Int { get }
    var gmol: Double { get }
    var valence: Int { get }
    var electronShellComposition: ElectronShell { get }
    var type: elementType { get }
}

protocol Compound {
    var elements: [Element] { get set }
    var elementCoeffs: [Int] { get set }
    var elementOxidStates: [Int] { get set }
    var gmol: Double { get set }
    var totalCharge: Int { get set }
}
// MARK: Group 1
class H: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s], numEperShell: [1])
    var str = "Hydrogen"
    var Z = 1
    var gmol = 1.008
    var valence = 1
    var type = elementType.hydrogen
}

class He: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s], numEperShell: [2])
    var str = "Helium"
    var Z = 2
    var gmol = 4.0026
    var valence = 2
    var type = elementType.nobleGas
}
// MARK: Group 2
class Li: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s], numEperShell: [2,1])
    var str = "Lithium"
    var Z = 3
    var gmol = 6.94
    var valence = 1
    var type = elementType.metal
}

class Be: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s], numEperShell: [2,2])
    var str = "Beryllium"
    var Z = 4
    var gmol = 9.0122
    var valence = 2
    var type = elementType.metal
}

class B: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p], numEperShell: [2,2,1])
    var str = "Boron"
    var Z = 5
    var gmol = 10.81
    var valence = 3
    var type = elementType.nonmetal
}
class C: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p], numEperShell: [2,2,2])
    var str = "Carbon"
    var Z = 6
    var gmol = 12.01
    var valence = 4
    var type = elementType.nonmetal
}
class N: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p], numEperShell: [2,2,3])
    var str = "Nitrogen"
    var Z = 7
    var gmol = 14.01
    var valence = 5
    var type = elementType.nonmetal
}
class O: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p], numEperShell: [2,2,4])
    var str = "Oxygen"
    var Z = 8
    var gmol = 15.999
    var valence = 6
    var type = elementType.nonmetal
}
class F: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p], numEperShell: [2,2,5])
    var str = "Fluorine"
    var Z = 9
    var gmol = 18.998
    var valence = 7
    var type = elementType.nonmetal
}
class Ne: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p], numEperShell: [2,2,6])
    var str = "Neon"
    var Z = 10
    var gmol = 20.180
    var valence = 8
    var type = elementType.nobleGas
}
// MARK: Group 3
class Na: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p,e._3s], numEperShell: [2,2,6,1])
    var str = "Sodium"
    var Z = 11
    var gmol = 22.990
    var valence = 1
    var type = elementType.metal
}
class Mg: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p,e._3s], numEperShell: [2,2,6,2])
    var str = "Magnesium"
    var Z = 12
    var gmol = 24.350
    var valence = 2
    var type = elementType.metal
}
class Al: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p,e._3s,e._3p], numEperShell: [2,2,6,2,1])
    var str = "Aluminum"
    var Z = 13
    var gmol = 26.982
    var valence = 3
    var type = elementType.metal
}
class Si: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p,e._3s,e._3p], numEperShell: [2,2,6,2,2])
    var str = "Silicon"
    var Z = 14
    var gmol = 28.035
    var valence = 4
    var type = elementType.metalloid
}
class P: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p,e._3s,e._3p], numEperShell: [2,2,6,2,3])
    var str = "Phosphorus"
    var Z = 15
    var gmol = 30.974
    var valence = 5
    var type = elementType.metalloid
}
class S: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p,e._3s,e._3p], numEperShell: [2,2,6,2,4])
    var str = "Sulfur"
    var Z = 16
    var gmol = 32.06
    var valence = 6
    var type = elementType.nonmetal
}


class Cr: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p,e._3s,e._3p,e._4s,e._3d], numEperShell: [2,2,6,2,6,1,4])
    var str = "Chromium"
    var Z = 24
    var gmol = 51.996
    var valence = 4
    var type = elementType.transitionMetal
}




