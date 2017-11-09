import PetriKit

public extension PTNet {




public func coverabilityGraph(from marking: CoverabilityMarking) -> CoverabilityGraph {

    let toReturn = CoverabilityGraph(marking : marking)
    var a_traiter = [toReturn]
    var traites = [CoverabilityGraph]()

    while let current = a_traiter.popLast(){ //tant qu'il reste un marquage a traiter
        traites.append(current)                 // on le met dans les marquages a traiter
        let m1 = convertMark(from: current.marking)

        for trans in self.transitions {

          if let m2 = trans.fire(from: m1){
            var m = omegaconvertMark(from: m2)

            for marquagePrec in toReturn{

              if m > marquagePrec.marking{ //si on a un marquage superieur

                for p in self.places{ //on check les places

                  if m[p]! > marquagePrec.marking[p]!{ //s'il y a plus de token dans la place d'un successor, on set un omega au niveau de la plus grande place
                    m[p] = .omega
                  }
                }
              }
            }

            if a_traiter.contains(where: {$0.marking == m}) { //si m est dans les marquages a traiter
              current.successors[trans] = a_traiter.first(where: {$0.marking == m}) //on le met dans les successor du current
            }

            else if traites.contains(where: {$0.marking == m}) { //si m est dans les marquages traités
              current.successors[trans] = traites.first(where: {$0.marking == m}) // //on le met dans les successor du current
            }

            else {                                                    //sinon s'il existe pas on le crée avant de le mettre en successor du current
              let marquagePlus = CoverabilityGraph(marking : m)
                a_traiter.append(marquagePlus)
                current.successors[trans] = marquagePlus
            }
          }
        }
  }
  return toReturn
}


public func convertMark (from marking: CoverabilityMarking) -> PTMarking {    //permet de choper les transitions pour les tirer
      var marquage : PTMarking = [:]

      for p in self.places{
        marquage[p] = 111

        for i in 0...111{

          if UInt(i) == marking[p]!{
            marquage[p] = UInt(i)
          }
        }
      }
      return marquage
    }

    public func omegaconvertMark (from marking: PTMarking) -> CoverabilityMarking {   //permet de tirer les transitions pour le cas où il y a un omega dedans
      var marquage : CoverabilityMarking = [:]

      for p in self.places{
        if marking[p]!<111{
          marquage[p] = .some(marking[p]!)
        }else{
          marquage[p] = .omega
        }
      }
      return marquage
}
}
