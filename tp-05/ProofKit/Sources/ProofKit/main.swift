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
print("Formule de base : ",f)
print("NNf:\n",f.nnf)
print("DNf:\n",f.dnf)
print("CNf:\n",f.cnf)
print("")
print("Formule de base : ",g)
print("NNF:\n",g.nnf)
print("DNf:\n",g.dnf)
print("CNf:\n",g.cnf)
print("")
print("Formule de base : ",h)
print("NNF:\n",h.nnf)
print("DNf:\n",h.dnf)
print("CNf:\n",h.cnf)
print("")
print("Formule de base : ",j)
print("NNF:\n",j.nnf)
print("DNf:\n",j.dnf)
print("CNf:\n",j.cnf)
print("")
print("Formule de base : ",k)
print("NNF:\n",k.nnf)
print("DNf:\n",k.dnf)
print("CNf:\n",k.cnf)

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
