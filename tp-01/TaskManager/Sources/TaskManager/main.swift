import TaskManagerLib

let taskManager = createTaskManager()

let taskPool    = taskManager.places.first { $0.name == "taskPool" }!
let processPool = taskManager.places.first { $0.name == "processPool" }!
let inProgress  = taskManager.places.first { $0.name == "inProgress" }!
let create   = taskManager.transitions.first { $0.name == "create" }!
let spawn      = taskManager.transitions.first { $0.name == "spawn" }!
let exec        = taskManager.transitions.first { $0.name == "exec" }!
let success     = taskManager.transitions.first { $0.name == "success" }!

//On va faire une succession d'étapes avec l'exemple mis dans le TP, ceci va conduire
//a un blocage du process dans le inProgress, ce qui est le probleme principal de ce reseau proposé
print("Avec le reseau de petri initial :")
let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
print(m1!)
let m2 = spawn.fire(from: m1!)
print(m2!)
let m3 = exec.fire(from: m2!)
print(m3!)
let m4 = spawn.fire(from: m3!)
print(m4!)
let m5 = exec.fire(from: m4!)
print(m5!)
let m6 = success.fire(from: m5!)
print(m6!)

let correctTaskManager = createCorrectTaskManager()

//Faisons a présent la meme succession avec le modifié, on remarque qu'il y a aura
//une erreur justement à cause du fait que le process se bloque.
// Donc on a bien corrigé le reseau.
print("Avec le reseau de petri modifie :")

let taskPool2    = correctTaskManager.places.first { $0.name == "taskPool" }!
let processPool2 = correctTaskManager.places.first { $0.name == "processPool" }!
let inProgress2  = correctTaskManager.places.first { $0.name == "inProgress" }!
let compteprocess = correctTaskManager.places.first { $0.name == "compteprocess"}!
let create2   = correctTaskManager.transitions.first { $0.name == "create" }!
let spawn2      = correctTaskManager.transitions.first { $0.name == "spawn" }!
let exec2        = correctTaskManager.transitions.first { $0.name == "exec" }!
let success2     = correctTaskManager.transitions.first { $0.name == "success" }!


let m7 = create2.fire(from: [taskPool2: 0, processPool2: 0, inProgress2: 0, compteprocess: 1])
print(m7!)
let m8 = spawn2.fire(from: m7!)
print(m8!)
let m9 = exec2.fire(from: m8!)
print(m9!)
let m10 = spawn2.fire(from: m9!)
print(m10!)
if (exec2.fire(from: m10!) == nil) {
  print("FATAL ERROR, TRANSITION NON FRANCHISSABLE")
}
//let m11 = success2.fire(from: m10!)
//print(m11!)
