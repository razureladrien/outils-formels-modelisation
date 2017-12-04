infix operator =>: LogicalDisjunctionPrecedence

public protocol BooleanAlgebra {

    static prefix func ! (operand: Self) -> Self
    static        func ||(lhs: Self, rhs: @autoclosure () throws -> Self) rethrows -> Self
    static        func &&(lhs: Self, rhs: @autoclosure () throws -> Self) rethrows -> Self

}

extension Bool: BooleanAlgebra {}

public enum Formula {

    /// p
    case proposition(String)

    /// ¬a
    indirect case negation(Formula)

    public static prefix func !(formula: Formula) -> Formula {
        return .negation(formula)
    }

    /// a ∨ b
    indirect case disjunction(Formula, Formula)

    public static func ||(lhs: Formula, rhs: Formula) -> Formula {
        return .disjunction(lhs, rhs)
    }

    /// a ∧ b
    indirect case conjunction(Formula, Formula)

    public static func &&(lhs: Formula, rhs: Formula) -> Formula {
        return .conjunction(lhs, rhs)
    }

    /// a → b
    indirect case implication(Formula, Formula)

    public static func =>(lhs: Formula, rhs: Formula) -> Formula {
        return .implication(lhs, rhs)
    }

    /// The negation normal form of the formula. NNF
    public var nnf: Formula {
        switch self {
        case .proposition(_):
            return self
        case .negation(let a):
            switch a {
            case .proposition(_):
                return self
            case .negation(let b):
                return b.nnf
            case .disjunction(let b, let c):
                return (!b).nnf && (!c).nnf
            case .conjunction(let b, let c):
                return (!b).nnf || (!c).nnf
            case .implication(_):
                return (!a.nnf).nnf
            }
        case .disjunction(let b, let c):
            return b.nnf || c.nnf
        case .conjunction(let b, let c):
            return b.nnf && c.nnf
        case .implication(let b, let c):
            return (!b).nnf || c.nnf
        }
    }

    /// The disjunctive normal form of the formula.
    public var dnf: Formula {

/////////////////////////CONDITONS//////////////////////////
        switch self.nnf { //les premiers etapes de la nnf sont utiles pour la dnf
        case .proposition(_): //si c'est deja un proposition rien besoin de faire
          return self.nnf
        case .negation(_): //pareil si c'est une negation
          return self.nnf
///////////////////////////D'ARRET///////////////////////////

        case .disjunction(let a, let b): //si c est une disjonction alors on retourne la disjonction des dnf des deux termes(on voit si c'est possible de les developper)
          return a.dnf || b.dnf
        case .conjunction(let a, let b): //dans le cas d'une conjonction on va chercher à developper
          switch a {
          case .disjunction(let c, let d): //si le terme de gauche de la conjonction est une disjonction alors on distribue
            return ((c.dnf && b.dnf) || (d.dnf && b.dnf)).dnf //on distribue et on refait une dnf sur chaque terme et chaque sous terme
          default: break
          }
          // dans les autres cas on ne peut rien changer, car pas de distribution possible
          switch b {
          case .disjunction(let c, let d): //pareil mais avec le terme de droite
            return ((c.dnf && a.dnf) || (d.dnf && a.dnf)).dnf
          default: break
          }
        default :break
        }
      return self
    }



    /// The conjunctive normal form of the formula.
    public var cnf: Formula { //meme idee que pour la dnf sauf que les 'dnf' deviennent 'cnf' et echange les '&&' et les '||'

/////////////////////////CONDITONS//////////////////////////
      switch self.nnf { //les premiers etapes de la nnf sont utiles pour la cnf
      case .proposition(_): //si c'est deja un proposition rien besoin de faire
        return self.nnf
      case .negation(_): //pareil si c'est une negation
        return self.nnf
///////////////////////////D'ARRET///////////////////////////

      case .conjunction(let a, let b): //si c est une conjonction alors on test les deux termes pour voir si on peut les developper, et on return une disjonction de tout ca
        return a.cnf && b.cnf
      case .disjunction(let a, let b): //dans le cas d'une disjunction on va chercher à developper
        switch a {
        case .conjunction(let c, let d): //si le terme de gauche de la disjonction est une conjonction alors on distribue
          return ((c.cnf || b.cnf) && (d.cnf || b.cnf)).cnf //on distribue et on refait une dnf sur chaque terme et chaque sous terme
        default: break
        }
        // (dans les autres cas on ne peut rien changer, car pas de distribution possible)
        switch b {
        case .conjunction(let c, let d): //pareil mais avec le terme de droite
          return ((c.cnf || a.cnf) && (d.cnf || a.cnf)).cnf
        default: break
        }
      default :break
      }
    return self
    }

    /// The propositions the formula is based on.
    ///
    ///     let f: Formula = (.proposition("p") || .proposition("q"))
    ///     let props = f.propositions
    ///     // 'props' == Set<Formula>([.proposition("p"), .proposition("q")])
    public var propositions: Set<Formula> {
        switch self {
        case .proposition(_):
            return [self]
        case .negation(let a):
            return a.propositions
        case .disjunction(let a, let b):
            return a.propositions.union(b.propositions)
        case .conjunction(let a, let b):
            return a.propositions.union(b.propositions)
        case .implication(let a, let b):
            return a.propositions.union(b.propositions)
        }
    }

    /// Evaluates the formula, with a given valuation of its propositions.
    ///
    ///     let f: Formula = (.proposition("p") || .proposition("q"))
    ///     let value = f.eval { (proposition) -> Bool in
    ///         switch proposition {
    ///         case "p": return true
    ///         case "q": return false
    ///         default : return false
    ///         }
    ///     })
    ///     // 'value' == true
    ///
    /// - Warning: The provided valuation should be defined for each proposition name the formula
    ///   contains. A call to `eval` might fail with an unrecoverable error otherwise.
    public func eval<T>(with valuation: (String) -> T) -> T where T: BooleanAlgebra {
        switch self {
        case .proposition(let p):
            return valuation(p)
        case .negation(let a):
            return !a.eval(with: valuation)
        case .disjunction(let a, let b):
            return a.eval(with: valuation) || b.eval(with: valuation)
        case .conjunction(let a, let b):
            return a.eval(with: valuation) && b.eval(with: valuation)
        case .implication(let a, let b):
            return !a.eval(with: valuation) || b.eval(with: valuation)
        }
    }

}

extension Formula: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self = .proposition(value)
    }

}

extension Formula: Hashable {

    public var hashValue: Int {
        return String(describing: self).hashValue
    }

    public static func ==(lhs: Formula, rhs: Formula) -> Bool {
        switch (lhs, rhs) {
        case (.proposition(let p), .proposition(let q)):
            return p == q
        case (.negation(let a), .negation(let b)):
            return a == b
        case (.disjunction(let a, let b), .disjunction(let c, let d)):
            return (a == c) && (b == d)
        case (.conjunction(let a, let b), .conjunction(let c, let d)):
            return (a == c) && (b == d)
        case (.implication(let a, let b), .implication(let c, let d)):
            return (a == c) && (b == d)
        default:
            return false
        }
    }

}

extension Formula: CustomStringConvertible {

    public var description: String {
        switch self {
        case .proposition(let p):
            return p
        case .negation(let a):
            return "¬\(a)"
        case .disjunction(let a, let b):
            return "(\(a) ∨ \(b))"
        case .conjunction(let a, let b):
            return "(\(a) ∧ \(b))"
        case .implication(let a, let b):
            return "(\(a) → \(b))"
        }
    }

}
