> :warning: **Please ignore "wrong" usage of access levels**. It was intended to be multi-module app but I didn't finished it so that's why you could notice a access-level mess and some other code styling leaks.

# Exchange App

## iOS Examples

| ![ios1](img/ios1.png "ios1") | ![ios2](img/ios2.png "ios2") | ![ios2](img/ios3.png "ios3") |
|:---:|:---:|:---:|

## macOS Examples

| ![mac1](img/mac1.png "ios1") | ![mac2](img/mac2.png "mac2") |
|:---:|:---:|

## Compatibility
* iOS 13.0+ ( deoarece folosesc IBSegueAction pentru DI )
* macOS 15.0+ (e activat Catalyst)

## Tools
* Swift 5.2
* Xcode 11.5+

## Notes

* Butonul din dreapta sus a cardurilor de Currency are rolul de a schimba, random, currency-ul din ecranul curent. Modificarea nu este persistenta si nu se va aplica altor ecrane.
* In setari se pot configura, pentru toate ecranele urmatoarele setari. Setarile sunt persistente.

## App Settings
* Default Currency
* Refresh Rate
* Enable/Disable Auto-Refresh in ecranul History
* Start/End Date in ecranul Historu

De asemenea, se pot schimba cardurile din ecranul History fara modificari semnificative, din fisierul **AppDefaults.swift**

## Progres

* **Documentatie:** Au fost documentate layerele de Data si Networking momentan.
* **Unit Testing:** Am descoperit o problema in utilizarea unei dependinte in mai multe targeturi cu SPM. 

* *Am scris doua teste, dar, aplicatia fiind bazate pe RxSwift (care trebuie sa fie prezent atat in targetul de build cat si cel de teste), acestea au fost scrise doar ca exemplu.* 
* *Voi cauta o solutie pentru rezolvarea situatiei. (eventual trecerea catre CocoaPods sau Carthage)*

