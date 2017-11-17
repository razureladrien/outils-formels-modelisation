import PetriKit
import PhilosophersLib

do {
    enum C: CustomStringConvertible { //les types que je peux avoir
        case b, v, o

        var description: String {
            switch self {
            case .b: return "b"
            case .v: return "v"
            case .o: return "o"
            }
        }
    }

    func g(binding: PredicateTransition<C>.Binding) -> C { //comme sur la diapo 29/44 du cours
        switch binding["x"]! {
        case .b: return .v //g(b) = v
        case .v: return .b
        case .o: return .o
        }
    }

    let t1 = PredicateTransition<C>(
        preconditions: [
            PredicateArc(place: "p1", label: [.variable("x")]),//voir diapo 29/44 aussi
        ],
        postconditions: [
            PredicateArc(place: "p2", label: [.function(g)]), //passe la fonction g au dessus sur le label x
        ])

    let m0: PredicateNet<C>.MarkingType = ["p1": [.b, .b, .v, .v, .b, .o], "p2": []]
    guard let m1 = t1.fire(from: m0, with: ["x": .b]) else { //le fire prend en parametre le binding cette fois : x vaut b
        fatalError("Failed to fire.")
    }
    print(m1)
    guard let m2 = t1.fire(from: m1, with: ["x": .v]) else { //x vaut v
        fatalError("Failed to fire.")
    }
    print(m2)
}

print()

do {
    let philosophers = lockablePhilosophers(n: 3)
    for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
        print(m)
    }
}
