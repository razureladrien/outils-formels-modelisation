import ProofKitLib

let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"
let d: Formula = "d"
let f = (a => b)&&(a => c)&&(b => d)&&(c => d) |- (a => d)

print(f.isProvable)
print("\n \n")

let p = (a => b)&&(b => a) |- (a => b)&&(b => a)

print(p.isProvable)

let fait_beau: Formula = "fait_beau"
let va_uni: Formula = "va_uni"
let risque_pleuvoir: Formula = "risque_pleuvoir"
let etre_a_maison: Formula = "etre_a__maison"
let fait_exercice: Formula = "fait_exercice"
let relit_cours: Formula = "relit_cours"
let ciel_gris: Formula = "ciel_gris"
let etre_content: Formula = "etre_content"


let g = (fait_beau => va_uni)&&(risque_pleuvoir => !va_uni)&&(!etre_a_maison => va_uni)&&(etre_a_maison => (fait_exercice && relit_cours))&&(ciel_gris => risque_pleuvoir)&&(va_uni => (fait_exercice && etre_content))&&(fait_beau || ciel_gris) |- fait_exercice
print("\n \n")
print(g.isProvable)
