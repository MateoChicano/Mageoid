# Mageoid

Prototype de jeu 2D type Metroidvania développé avec **Godot 4.7** (projet dans `Mageoid/`).

## Lancer le projet

1. Ouvrir Godot 4.7.
2. Importer le dossier `Mageoid/` (qui contient `project.godot`).
3. Lancer la scène principale : `res://Interface/Menus/TitleScreen.tscn`.

## Contrôles principaux (par défaut)

- Déplacement : flèches / WASD (ZQSD selon clavier) / stick gauche
- Saut : `Espace` / bouton manette A
- Attaque : clic gauche / `I` / bouton manette X
- Viser : clic droit / `U` / gâchette L
- Changer d’arme : `O` / gâchette R
- Sélection d’arme : `P` / bouton manette LB
- Grappin : `L` (clavier)
- Pause : `Échap` / Start

Les actions sont configurables dans `Projet > Paramètres du projet > Input Map`.

## Structure

- `Mageoid/Entities/` : joueur, ennemis, projectiles
- `Mageoid/levels/` : niveaux et éléments de niveau
- `Mageoid/Interface/` : HUD et menus
- `Mageoid/Items/` : objets et améliorations
- `Pitch.txt` : notes d’intention / direction du projet

## Exports

Les presets d’export sont définis dans `Mageoid/export_presets.cfg`. Les builds générés doivent aller dans `Mageoid/Builds/` (ignoré par git) et ne doivent pas être commités.
