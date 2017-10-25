import PetriKit

public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}

public extension PTNet {

    public func markingGraph(from marking: PTMarking) -> MarkingGraph? {
        let tab_transitions = Array(transitions) //on met les transitions dans un tableau pour pouvoir les prendre (avec un set on pouvait pas parcourir)
        var firstmark = MarkingGraph(marking: marking, successors: [:]) // marquage initial
        var markages_done = [firstmark] //marquages deja faits
        var markages_to_do = [firstmark] //marquages qu'on va faire
        var current = firstmark //le marquage current est d'abord defini comme le premier marquage
        var current_fire = tab_transitions[0].fire(from: firstmark.marking) //fire depuis le current


        while (markages_to_do.count != 0) { //tant qu'il y a encore des marquages à traiter
          current = markages_to_do[0] //on traite a chaque fois le premier élément des marquages a traiter

          for i in 0...(tab_transitions.count-1) {

            if (tab_transitions[i].fire(from : current.marking) != nil){ //si c'est fireable
              current_fire = tab_transitions[i].fire(from: current.marking) //alors on fire
              var newMark = MarkingGraph(marking: current_fire!, successors: [:]) // on definit le nouveau marquage

              if (!markages_done.contains(where: { $0.marking == newMark.marking})){ //si le nouveau marquage a traiter n'est pas dans les marquages traités (empeche les doublons de marquages)
                markages_done.append(newMark) //alors je le met dans les marquages traités et à traiter
                markages_to_do.append(newMark)
                current.successors.updateValue(newMark, forKey: tab_transitions[i]) //ça devient un successor du current
              }

              if (newMark.marking == current.marking){
                current.successors.updateValue(current, forKey: tab_transitions[i]) //si jamais on a un marquage qui est egal au current alors on dit qu'il est successor de lui meme
              }
            }
          }
          markages_to_do.remove(at: 0) //je remove le marquage que je viens de traiter dans les marquages a traiter, permettra de stoper la boucle while à un moment
        }
        return firstmark //retourne le premier marquage qui est de type markingGraph
    }

}
