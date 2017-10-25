import PetriKit
import SmokersLib

// Instantiate the model.
let model = createModel()

// Retrieve places model.
guard let r  = model.places.first(where: { $0.name == "r" }),
      let p  = model.places.first(where: { $0.name == "p" }),
      let t  = model.places.first(where: { $0.name == "t" }),
      let m  = model.places.first(where: { $0.name == "m" }),
      let w1 = model.places.first(where: { $0.name == "w1" }),
      let s1 = model.places.first(where: { $0.name == "s1" }),
      let w2 = model.places.first(where: { $0.name == "w2" }),
      let s2 = model.places.first(where: { $0.name == "s2" }),
      let w3 = model.places.first(where: { $0.name == "w3" }),
      let s3 = model.places.first(where: { $0.name == "s3" })
else {
    fatalError("invalid model")
}

// Create the initial marking.
let initialMarking: PTMarking = [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]

let transitions = model.transitions //on récupère les transitions du reseau de pétri

func countNodes(to markingGraph : MarkingGraph) -> Int {
    var seen = [markingGraph]
    var toVisit = [markingGraph]

    while let current = toVisit.popLast() {
      for (_, successor) in current.successors {
          if !seen.contains(where: { $0 === successor }) {
              seen.append(successor)
              toVisit.append(successor)
          }
      }

    }

    return seen.count
}

func twosmokers(to markingGraph : MarkingGraph) -> Bool {
    var seen = [markingGraph]
    var toVisit = [markingGraph]

    while let current = toVisit.popLast() {
      for (_, successor) in current.successors {
          if !seen.contains(where: { $0 === successor }) {
              seen.append(successor)
              toVisit.append(successor)
              if (successor.marking[s1] == 1 && successor.marking[s2] == 1) || (successor.marking[s2] == 1 && successor.marking[s3] == 1) || (successor.marking[s3] == 1 && successor.marking[s1] == 1) {
                return true
              }

          }
      }

    }
    return false
}


func twoingredients(to markingGraph : MarkingGraph) -> Bool {
    var seen = [markingGraph]
    var toVisit = [markingGraph]

    while let current = toVisit.popLast() {
      for (_, successor) in current.successors {
          if !seen.contains(where: { $0 === successor }) {
              seen.append(successor)
              toVisit.append(successor)
              if successor.marking[p] == 2 || successor.marking[m] == 2 || successor.marking[t] == 2{
                return true
              }

          }
      }

    }
    return false
}



// Create the marking graph (if possible).
if let markingGraph = model.markingGraph(from: initialMarking) {
    print("Exercice 4 ")
    print("")
    print("Question 1)")
    var states = countNodes(to : markingGraph)
    print("Il y a",states, "états")
    print("")
    print("Question 2)")
    if twosmokers(to : markingGraph) == true{
      print("Il est possible d'avoir 2 fumeurs en même temps")
    }
    else{
      print("Il est impossible d'avoir deux fumeurs en même temps")
    }
    print("")
    print("Question 2)")
    if twoingredients(to : markingGraph) == true{
      print("Il est possible d'avoir 2 ingredients en même temps sur la table")
    }
    else{
      print("Il est impossible d'avoir deux ingredients en même temps sur la table")
    }
}
