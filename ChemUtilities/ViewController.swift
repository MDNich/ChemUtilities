//
//  ViewController.swift
//  ChemUtilities
//
//  Created by שמים זורעי כוכבים on 7/16/24.
//


import Cocoa



class ViewController: NSViewController {
    
    var elementSymbolMap : [String:Element] = [
        "H" : H(),
        "He" : He(),
        "Li" : Li(),
        "Be" : Be(),
        "B" : B(),
        "C" : C(),
        "N" : N(),
        "O" : O(),
        "F" : F(),
        "Ne" : Ne(),
        
        "Cr" : Cr()
    ]
    

    @IBOutlet weak var eqField: NSTextField!
    
    @IBOutlet weak var eqType: NSSegmentedControl!
    
    @IBOutlet weak var equationDisplayField: NSTextField!
    
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
        
        //let input = "C6H12O6 + O2 -> CO2 + H2O"//"NO2(-) + Cr2O7(2-) -> Cr(3+) + NO3(-)" // TODO Replace with input from GUI
        
        let input = eqField.stringValue
        
        print("Parsing reaction \(input), parsed reactants and products:")
        // requirements: separate species with ' + ' and products and reactants with ' -> '.
        
        
        // MARK: Parse Equation
        
        let reactProd = input.components(separatedBy: " -> ")
        let reactants = reactProd[0]
        let products = reactProd[1]
        var reactParsed = reactants.components(separatedBy: " + ")
        var prodParsed = products.components(separatedBy: " + ")
        var ctr = 0
        for reactant in reactParsed {
            reactParsed[ctr] = reactant.trimmingCharacters(in: .whitespacesAndNewlines)
            ctr = ctr + 1
        }
        ctr = 0
        for product in prodParsed {
            prodParsed[ctr] = product.trimmingCharacters(in: .whitespacesAndNewlines)
            ctr = ctr + 1
        }
        //print(reactParsed)
        //print(prodParsed)
        let nRct = reactParsed.count
        let nPdt = prodParsed.count
        var reactantsUnderstood: [Compound] = []
        var productsUnderstood: [Compound] = []
        for reactant in reactParsed {
            var ctr1 = 0
            var elements: [Element] = []
            var coeffs: [Int] = []
            var charge: Int = 0
            let reactChars = Array(reactant)
            //print(reactChars)
            for reactChar in reactChars {
                //print("inspecting char \(reactChar) index \(ctr1)")
                if reactChar.isUppercase {
                    //print("character is uppercase")
                    //print("check1 : \(ctr1 < reactChars.count-1)")
                    //print("check2 : \(reactChars[ctr1+1]) \(reactChars[ctr+1].isUppercase)")
                    if ctr1 < reactChars.count-1 && reactChars[ctr1+1].isLowercase {
                        //print("Found element \(reactChar)\(reactChars[ctr1+1])")
                        elements.append(elementSymbolMap[String(reactChar) + String(reactChars[ctr1+1])]!)
                        if ctr1 < reactChars.count-2 && reactChars[ctr1+2].isNumber {
                            coeffs.append(Int(String(reactChars[ctr1+2]))!)
                        }
                        else {
                            coeffs.append(1)
                        }
                    }
                    else {
                        //print("Found element \(reactChar)")
                        elements.append(elementSymbolMap[String(reactChar)]!)
                        if ctr1 < reactChars.count-1 && reactChars[ctr1+1].isNumber {
                            if ctr1 < reactChars.count-2 && reactChars[ctr1+2].isNumber {
                                coeffs.append(Int(String(reactChars[ctr1+1...ctr1+2]))!)
                            }
                            else {
                                coeffs.append(Int(String(reactChars[ctr1+1]))!)
                            }
                        }
                        else {
                            coeffs.append(1)
                        }
                    }
                }
                if reactChars[ctr1] == "(" {
                    if reactChars.count-3 == ctr1 {
                        if reactChars[ctr1+1] == "-" {
                            charge = -1
                        }
                        else if reactChars[ctr1+1] == "+" {
                            charge = 1
                        }
                    }
                    else {
                        charge = Int(String(reactChars[ctr1+1...reactChars.count-3]))!
                        if(reactChars[reactChars.count-2] == "-") {
                            charge *= -1
                        }
                    }
                }
                ctr1 += 1
            }
            //print(elements)
            //print(coeffs)
            //print(charge)
            reactantsUnderstood.append(Compound(elements: elements, elementCoeffs: coeffs, totalCharge: charge))
        }
        for product in prodParsed {
            var ctr1 = 0
            var elements: [Element] = []
            var coeffs: [Int] = []
            var charge: Int = 0
            let prodChars = Array(product)
            //print(prodChars)
            for prodChar in prodChars {
                //print("inspecting char \(reactChar) index \(ctr1)")
                if prodChar.isUppercase {
                    //print("character is uppercase")
                    //print("check1 : \(ctr1 < reactChars.count-1)")
                    //print("check2 : \(reactChars[ctr1+1]) \(reactChars[ctr+1].isUppercase)")
                    if ctr1 < prodChars.count-1 && prodChars[ctr1+1].isLowercase {
                        //print("Found element \(reactChar)\(reactChars[ctr1+1])")
                        elements.append(elementSymbolMap[String(prodChar) + String(prodChars[ctr1+1])]!)
                        if ctr1 < prodChars.count-2 && prodChars[ctr1+2].isNumber {
                            coeffs.append(Int(String(prodChars[ctr1+2]))!)
                        }
                        else {
                            coeffs.append(1)
                        }
                    }
                    else {
                        //print("Found element \(reactChar)")
                        elements.append(elementSymbolMap[String(prodChar)]!)
                        if ctr1 < prodChars.count-1 && prodChars[ctr1+1].isNumber {
                            coeffs.append(Int(String(prodChars[ctr1+1]))!)
                        }
                        else {
                            coeffs.append(1)
                        }
                    }
                }
                if prodChars[ctr1] == "(" {
                    if prodChars.count-3 == ctr1 {
                        if prodChars[ctr1+1] == "-" {
                            charge = -1
                        }
                        else if prodChars[ctr1+1] == "+" {
                            charge = 1
                        }
                    }
                    else {
                        charge = Int(String(prodChars[ctr1+1...prodChars.count-3]))!
                        if(prodChars[prodChars.count-2] == "-") {
                            charge *= -1
                        }
                    }
                }
                ctr1 += 1
            }
            //print(elements)
            //print(coeffs)
            //print(charge)
            productsUnderstood.append(Compound(elements: elements, elementCoeffs: coeffs, totalCharge: charge))
        }
        
        print("Parsed reactants: \(reactantsUnderstood)")
        print("Parsed products: \(productsUnderstood)")
        
        // MARK: Balance Equation
        
        
        let type = eqType.selectedSegment == 0 ? reactionType.normal : (eqType.selectedSegment == 1 ? reactionType.redox : reactionType.acidbase)
        
        let isRedox = type == reactionType.normal
        
        // if not redox, create linear algebra system
        
        var allElements: [Element] = []
        for comp in reactantsUnderstood { // Enough to look at the reactants
            for el in comp.elements {
                //print("Inspecting element \(el) in compound \(comp)")
                //print(allElements)
                var flag = 0
                for i in allElements {
                    if(i.Z == el.Z) {
                        flag = 1
                        break
                    }
                }
                if(flag == 1) {
                    continue
                }
                allElements.append(el)
            }
        }
        //print(allElements)
        
        var matrix: [[Double]] = []
        var col = 0
        for comp in reactantsUnderstood + productsUnderstood {
            var row = 0
            var elementCoeffs: [Double] = Array(repeating: 0, count: allElements.count)
            for el in allElements {
                let data = comp.isElementPresent(el: el)
                if(data[0] == 1) {
                    elementCoeffs[row] = Double(comp.elementCoeffs[data[1]])
                }
                row += 1
            }
            matrix.append(elementCoeffs)
            col += 1
        }
        var transposedMatrix : [[Double]] = []
        
        for j in 0...matrix[0].count-1 {
            transposedMatrix.append([Double](repeating: 0, count: matrix.count))
            //print(j)
        }
        
        for i in 0...matrix.count-1 {
            for j in 0...matrix[0].count-1 {
                transposedMatrix[j][i] = matrix[i][j]
            }
            
        }
        //print("Row reducing the following matrix: ")
        //print(transposedMatrix)
        
        // FROM ROSETTACODE - SWIFT
        var m = transposedMatrix
        let rows = m.count
        let cols = m[0].count
        var lead = 0
        for r in 0..<rows {
           if (cols <= lead) { break }
           var i = r
           while (m[i][lead] == 0) {
               i += 1
               if (i == rows) {
                   i = r
                   lead += 1
                   if (cols == lead) {
                       lead -= 1
                       break
                   }
               }
           }
           for j in 0..<cols {
               let temp = m[r][j]
               m[r][j] = m[i][j]
               m[i][j] = temp
           }
           let div = m[r][lead]
           if (div != 0) {
               for j in 0..<cols {
                   m[r][j] /= div
               }
           }
           for j in 0..<rows {
               if (j != r) {
                   let sub = m[j][lead]
                   for k in 0..<cols {
                       m[j][k] -= (sub * m[r][k])
                   }
               }
           }
           lead += 1
        }
        
        // row reduction complete, the last entry in each row will determine the coefficients.
        var lastCol: [Double] = []
        for i in 0...m.count-1 {
            lastCol.append(abs(m[i].last!))
        }
        let factor = 1/lastCol.min()!
        //print(factor)
        var balancedCoeffs: [Int] = []
        for i in 0...m.count-1 {
            balancedCoeffs.append(Int(abs(factor*lastCol[i])))
        }
        balancedCoeffs.append(Int(factor))
        //print(balancedCoeffs)
        
        let balancedReaction = Reaction(compounds: reactantsUnderstood+productsUnderstood, compoundCoeffs: balancedCoeffs, nReact: reactantsUnderstood.count, balanced: true, type: type)
        
        print("Finished balancing reaction, result is")
        print(balancedReaction)
        equationDisplayField.stringValue = balancedReaction.description
        
        
        
        
        
        
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

enum reactionType {
    case normal
    case redox
    case acidbase
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
    var symb: String { get }
    var Z: Int { get }
    var gmol: Double { get }
    var valence: Int { get }
    var electronShellComposition: ElectronShell { get }
    var type: elementType { get }
}

// MARK: Reaction
class Reaction: NSObject {
    var compounds: [Compound]
    var compoundCoeffs: [Int]
    var nReact: Int
    var enthalpy: Double?
    var entropy: Double?
    var gibbsAt298K: Double?
    var balanced: Bool = false
    var type: reactionType = reactionType.normal
    
    init(compounds: [Compound], compoundCoeffs: [Int], nReact: Int, balanced: Bool, type: reactionType) {
        self.compounds = compounds
        self.compoundCoeffs = compoundCoeffs
        self.nReact = nReact
        self.enthalpy = nil
        self.entropy = nil
        self.gibbsAt298K = nil
        self.balanced = balanced
        self.type = type
        //print("Created reaction object with \(nReact) reactants yielding \(compounds.count-nReact) products")
    }
    
    public override var description: String {
        //print(compounds)
        //print(compoundCoeffs)
        var ret = ""
        for i in 0...nReact-1 {
            //print(i)
            var retIni = ""
            if(compoundCoeffs[i] == 1) {
                retIni = "\(compounds[i].description.components(separatedBy: " ")[0])"
            }
            else {
                retIni = "\(compoundCoeffs[i])\(compounds[i].description.components(separatedBy: " ")[0])"
            }
            if(ret == "") {
                ret = retIni
                //print(ret)
                continue
            }
            ret = "\(ret) + \(retIni)"
            //print(ret)
        }
        ret = "\(ret) -> "
        //print(ret)
        let ret0 = ret
        for i in nReact...compounds.count-1 {
            ret = ret != ret0 ? "\(ret) + \(compoundCoeffs[i])\(compounds[i].description.components(separatedBy: " ")[0])" : "\(ret)\(compoundCoeffs[i])\(compounds[i].description.components(separatedBy: " ")[0])"
        }
        return ret
    }
    
}

class Compound: NSObject {
    var elements: [Element]
    var elementCoeffs: [Int]
    var gmol: Double
    var totalCharge: Int
    
    init(elements: [Element], elementCoeffs: [Int], totalCharge: Int) {
        self.elements = elements
        self.elementCoeffs = elementCoeffs
        self.totalCharge = totalCharge
        self.gmol = 0
        var ctr = 0
        for element in elements {
            self.gmol += element.gmol*Double(elementCoeffs[ctr])
            ctr += 1
        }
    }
    
    public func isElementPresent(el: Element) -> [Int] {
        var flag = 0
        var ind = 0
        for el0 in elements {
            if(el0.Z == el.Z) {
                flag = 1
                break
            }
            ind += 1
        }
        return [flag,ind]
    }
    
    
    public override var description: String {
        /*print("---")
        print(elements)
        print(elementCoeffs)
        print(totalCharge)
        print("---")*/
        
        let n = elements.count
        var rep = ""
        for i in 0...n-1 {
            rep = "\(rep)\(elements[i].symb)\(elementCoeffs[i] == 1 ? "" : String(elementCoeffs[i]))"
        }
        if(totalCharge == -1) {
            rep = "\(rep)(-)"
        }
        else if(totalCharge == 1) {
            rep = "\(rep)(+)"
        }
        else if(totalCharge > 1) {
            rep = "\(rep)(\(totalCharge)+)"
        }
        else if(totalCharge < -1) {
            rep = "\(rep)(\(String(totalCharge).dropFirst())-)"
        }
        
        return "\(rep) (\(gmol) g/mol)"
    }
}
// MARK: Group 1
class H: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s], numEperShell: [1])
    var str = "Hydrogen"
    var symb = "H"
    var Z = 1
    var gmol = 1.008
    var valence = 1
    var type = elementType.hydrogen
}

class He: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s], numEperShell: [2])
    var str = "Helium"
    var symb = "He"
    var Z = 2
    var gmol = 4.0026
    var valence = 2
    var type = elementType.nobleGas
}
// MARK: Group 2
class Li: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s], numEperShell: [2,1])
    var str = "Lithium"
    var symb = "Li"
    var Z = 3
    var gmol = 6.94
    var valence = 1
    var type = elementType.metal
}

class Be: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s], numEperShell: [2,2])
    var str = "Beryllium"
    var symb = "Be"
    var Z = 4
    var gmol = 9.0122
    var valence = 2
    var type = elementType.metal
}

class B: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p], numEperShell: [2,2,1])
    var str = "Boron"
    var symb = "B"
    var Z = 5
    var gmol = 10.81
    var valence = 3
    var type = elementType.nonmetal
}
class C: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p], numEperShell: [2,2,2])
    var str = "Carbon"
    var symb = "C"
    var Z = 6
    var gmol = 12.01
    var valence = 4
    var type = elementType.nonmetal
}
class N: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p], numEperShell: [2,2,3])
    var str = "Nitrogen"
    var symb = "N"
    var Z = 7
    var gmol = 14.01
    var valence = 5
    var type = elementType.nonmetal
}
class O: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p], numEperShell: [2,2,4])
    var str = "Oxygen"
    var symb = "O"
    var Z = 8
    var gmol = 15.999
    var valence = 6
    var type = elementType.nonmetal
}
class F: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p], numEperShell: [2,2,5])
    var str = "Fluorine"
    var symb = "F"
    var Z = 9
    var gmol = 18.998
    var valence = 7
    var type = elementType.nonmetal
}
class Ne: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p], numEperShell: [2,2,6])
    var str = "Neon"
    var symb = "Ne"
    var Z = 10
    var gmol = 20.180
    var valence = 8
    var type = elementType.nobleGas
}
// MARK: Group 3
class Na: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p,e._3s], numEperShell: [2,2,6,1])
    var str = "Sodium"
    var symb = "Na"
    var Z = 11
    var gmol = 22.990
    var valence = 1
    var type = elementType.metal
}
class Mg: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p,e._3s], numEperShell: [2,2,6,2])
    var str = "Magnesium"
    var symb = "Mg"
    var Z = 12
    var gmol = 24.350
    var valence = 2
    var type = elementType.metal
}
class Al: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p,e._3s,e._3p], numEperShell: [2,2,6,2,1])
    var str = "Aluminum"
    var symb = "Al"
    var Z = 13
    var gmol = 26.982
    var valence = 3
    var type = elementType.metal
}
class Si: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p,e._3s,e._3p], numEperShell: [2,2,6,2,2])
    var str = "Silicon"
    var symb = "Si"
    var Z = 14
    var gmol = 28.035
    var valence = 4
    var type = elementType.metalloid
}
class P: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p,e._3s,e._3p], numEperShell: [2,2,6,2,3])
    var str = "Phosphorus"
    var symb = "P"
    var Z = 15
    var gmol = 30.974
    var valence = 5
    var type = elementType.metalloid
}
class S: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p,e._3s,e._3p], numEperShell: [2,2,6,2,4])
    var str = "Sulfur"
    var symb = "S"
    var Z = 16
    var gmol = 32.06
    var valence = 6
    var type = elementType.nonmetal
}


class Cr: Element {
    var electronShellComposition = ElectronShell(shells: [e._1s,e._2s,e._2p,e._3s,e._3p,e._4s,e._3d], numEperShell: [2,2,6,2,6,1,4])
    var str = "Chromium"
    var symb = "Cr"
    var Z = 24
    var gmol = 51.996
    var valence = 4
    var type = elementType.transitionMetal
}




