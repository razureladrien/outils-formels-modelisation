import PetriKit
import PhilosophersLib
  print("\n")
  let philosophers = lockFreePhilosophers(n: 5)
  let philosophersfree = philosophers.markingGraph(from: philosophers.initialMarking!)
  print("Il y a ",philosophersfree!.count,"marquages possibles dans le modele des philosophes non bloquable a 5 philosophes \n")
  let philosophersloc = lockablePhilosophers(n: 5)
  let philosopherslock = philosophersloc.markingGraph(from: philosophersloc.initialMarking!)
  print("Il y a",philosopherslock!.count,"marquages possibles dans le modele des philosophes bloquable a 5 philosophes\n")
  for noeud in philosopherslock! {
    if noeud.successors.count == 0 {
      print("Un exemple de bloquage:\n",noeud.marking)
      break
  }

}
