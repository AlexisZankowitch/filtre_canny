# filtre_canny
tp analyse image enssat 2016


Pour pouvoir tester vous même le programme vous devez utiliser la fonction : 
```
cannyFilter(base_path, step_hist, threshold,factorTh,img)
```
Les paramètre de cette fonction sont : 
- base_path : (string) chemin vers le dossier contenant le code source et les images
- step_hist : (int) pas de l’histogramme, influence la qualité de l’hysteresis
- threshold : (int) facteur déterminant le seuil bas de l’hysteresis
- img : (string) chemin vers l’image à utiliser
  - le programme est fourni avec 3 images pour tester l’algorithme vous pouvez les utiliser en remplaçant le paramètre img de la fonction par “1” “2” ou “3”.
