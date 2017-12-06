import ProofKitLib

///////////////////////////////////TEST NNF CNF ET DNF/////////////////////////////////
let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"
let d: Formula = "d"
let e: Formula = "e"
let f = (a => b) || !(a => c)
let g = (a => (b => c)) && !(a && c)
let h = (!a || b && c) && a
let j = a || (b || (c && a))
let k = a || !(b && (c || d))
print("\n\n")
print("TESTS DE L'IMPLEMENTATION: \n")
print("Formule de base : ",f)
print("NNf:",f.nnf)
print("DNf:",f.dnf)
print("CNf:",f.cnf)
print("")
print("Formule de base : ",g)
print("NNF:",g.nnf)
print("DNf:",g.dnf)
print("CNf:",g.cnf)
print("")
print("Formule de base : ",h)
print("NNF:",h.nnf)
print("DNf:",h.dnf)
print("CNf:",h.cnf)
print("")
print("Formule de base : ",j)
print("NNF:",j.nnf)
print("DNf:",j.dnf)
print("CNf:",j.cnf)
print("")
print("Formule de base : ",k)
print("NNF:",k.nnf)
print("DNf:",k.dnf)
print("CNf:",k.cnf)

/*let booleanEvaluation = f.eval { (proposition) -> Bool in
    switch proposition {
        case "p": return true
        case "q": return false
        default : return false
    }
}
//print(booleanEvaluation)

enum Fruit: BooleanAlgebra {

    case apple, orange

    static prefix func !(operand: Fruit) -> Fruit {
        switch operand {
        case .apple : return .orange
        case .orange: return .apple
        }
    }

    static func ||(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.orange, .orange): return .orange
        case (_ , _)           : return .apple
        }
    }

    static func &&(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.apple , .apple): return .apple
        case (_, _)           : return .orange
        }
    }

}

let fruityEvaluation = f.eval { (proposition) -> Fruit in
    switch proposition {
        case "p": return .apple
        case "q": return .orange
        default : return .orange
    }
}
//print(fruityEvaluation) */
