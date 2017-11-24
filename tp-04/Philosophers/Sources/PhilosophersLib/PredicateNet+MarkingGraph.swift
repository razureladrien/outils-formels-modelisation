extension PredicateNet {




    /// Returns the marking graph of a bounded predicate net.
    public func markingGraph(from marking: MarkingType) -> PredicateMarkingNode<T>? {
      var transitions = Array(self.transitions) //on met les transitions dans un tableau pour pouvoir les prendre
      let mark = PredicateMarkingNode<T>(marking: marking, successors: [:]) //marquage init defini comme PredicateMarkingNode ici
      var mark_to_do = [mark]//marquages qu'on va faire
      var mark_done = [mark]//marquages deja faits

      while (mark_to_do.count != 0) {//tant qu'il y a encore des marquages à traiter
        let current_mark = mark_to_do[0] //on traite a chaque fois le premier élément des marquages a traiter

        for k in 0...(transitions.count-1) {
          let binding_table = transitions[k].fireableBingings(from: current_mark.marking)//tableau des bindings
          var newBind : PredicateBindingMap<T> = [:] //nouveau binding

          for binding in binding_table { //pour chaque binding

            if let new_fire = transitions[k].fire(from: current_mark.marking, with: binding) {
              let new_mark = PredicateMarkingNode<T>(marking: new_fire, successors: [:]) //si c'est fireable alors on fire

              if mark_done.contains(where: { PredicateNet.greater(new_mark.marking, $0.marking)}) == true { //Si trop grand alors on arrete
                return nil
              }

              if mark_done.contains(where: { PredicateNet.equals($0.marking, new_mark.marking)}) == false {//s'il est pas encore traité alors on append dans les marquages pour le traiter
                mark_to_do.append(new_mark)
                mark_done.append(new_mark)
                newBind[binding] = new_mark
                current_mark.successors.updateValue(newBind, forKey: transitions[k])//nouveau successor
              }
              else { //par contre s'il est deja traité
                for MARK in mark_done {
                  if PredicateNet.equals(MARK.marking, new_mark.marking) == true {//on trouve son successor
                    newBind[binding] = MARK
                    current_mark.successors.updateValue(newBind, forKey: transitions[k])//et on le set
                  }
                }
              }
            }

          }
        }

        mark_to_do.remove(at: 0) //je remove le marquage que je viens de traiter dans les marquages a traiter, permettra de stoper la boucle while à un moment
      }


        // Note that I created the two static methods `equals(_:_:)` and `greater(_:_:)` to help
        // you compare predicate markings. You can use them as the following:
        //
        //     PredicateNet.equals(someMarking, someOtherMarking)
        //     PredicateNet.greater(someMarking, someOtherMarking)
        //
        // You may use these methods to check if you've already visited a marking, or if the model
        // is unbounded.

        return mark //retourne le graph de marquage des bindings
    }

    // MARK: Internals

    private static func equals(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }
        for (place, tokens) in lhs {
            guard tokens.count == rhs[place]!.count else { return false }
            for t in tokens {
                guard tokens.filter({ $0 == t }).count == rhs[place]!.filter({ $0 == t }).count
                    else {
                        return false
                }
            }
        }
        return true
    }

    private static func greater(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }

        var hasGreater = false
        for (place, tokens) in lhs {
            guard tokens.count >= rhs[place]!.count else { return false }
            hasGreater = hasGreater || (tokens.count > rhs[place]!.count)
            for t in rhs[place]! {
                guard tokens.filter({ $0 == t }).count >= rhs[place]!.filter({ $0 == t }).count
                    else {
                        return false
                }
            }
        }
        return hasGreater
    }

}

/// The type of nodes in the marking graph of predicate nets.
public class PredicateMarkingNode<T: Equatable>: Sequence {

    public init(
        marking   : PredicateNet<T>.MarkingType,
        successors: [PredicateTransition<T>: PredicateBindingMap<T>] = [:])
    {
        self.marking    = marking
        self.successors = successors
    }

    public func makeIterator() -> AnyIterator<PredicateMarkingNode> {
        var visited = [self]
        var toVisit = [self]

        return AnyIterator {
            guard let currentNode = toVisit.popLast() else {
                return nil
            }

            var unvisited: [PredicateMarkingNode] = []
            for (_, successorsByBinding) in currentNode.successors {
                for (_, successor) in successorsByBinding {
                    if !visited.contains(where: { $0 === successor }) {
                        unvisited.append(successor)
                    }
                }
            }

            visited.append(contentsOf: unvisited)
            toVisit.append(contentsOf: unvisited)

            return currentNode
        }
    }

    public var count: Int {
        var result = 0
        for _ in self {
            result += 1
        }
        return result
    }

    public let marking: PredicateNet<T>.MarkingType

    /// The successors of this node.
    public var successors: [PredicateTransition<T>: PredicateBindingMap<T>]

}

/// The type of the mapping `(Binding) ->  PredicateMarkingNode`.
///
/// - Note: Until Conditional conformances (SE-0143) is implemented, we can't make `Binding`
///   conform to `Hashable`, and therefore can't use Swift's dictionaries to implement this
///   mapping. Hence we'll wrap this in a tuple list until then.
public struct PredicateBindingMap<T: Equatable>: Collection {

    public typealias Key     = PredicateTransition<T>.Binding
    public typealias Value   = PredicateMarkingNode<T>
    public typealias Element = (key: Key, value: Value)

    public var startIndex: Int {
        return self.storage.startIndex
    }

    public var endIndex: Int {
        return self.storage.endIndex
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }

    public subscript(index: Int) -> Element {
        return self.storage[index]
    }

    public subscript(key: Key) -> Value? {
        get {
            return self.storage.first(where: { $0.0 == key })?.value
        }

        set {
            let index = self.storage.index(where: { $0.0 == key })
            if let value = newValue {
                if index != nil {
                    self.storage[index!] = (key, value)
                } else {
                    self.storage.append((key, value))
                }
            } else if index != nil {
                self.storage.remove(at: index!)
            }
        }
    }

    // MARK: Internals

    private var storage: [(key: Key, value: Value)]

}

extension PredicateBindingMap: ExpressibleByDictionaryLiteral {

    public init(dictionaryLiteral elements: ([Variable: T], PredicateMarkingNode<T>)...) {
        self.storage = elements
    }

}
