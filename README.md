# Projet IF36 - Avatar et le maître du R

### Membres

- Hoang-Viêt LE
- Paul LASSASSEIGNE
- Jules PERRIN
- Florian LOPITAUX

## Données

Dans le cadre de notre projet, nous avons choisi d'étudier diverses jeux de données autour du catalogue de jeux Steam.
Les datasets utilisés lors de ce projet sont les suivants :
- [Dataset de NewbieIndieGameDev datant d'Octobre 2024](https://github.com/NewbieIndieGameDev/steam-insights) (140 000 jeux recensés)

Ces datasets possèdent de nombreuses variables. Nous allons nous concentrer sur ceux qui nous semblent assez pertinent à analyser.
Le dataset de NewbieIndieGameDev contient plusieurs fichiers avec des variables suivantes :

-   **`games.csv`** : regroupe les métadonnées des jeux, notamment :
    -   `app_id` : identifiant unique du jeu sur Steam
    -   `name` : titre du jeu
    -   `price` : prix d'achat
    
-   **`steamspy.csv`** : fournit des données issues de SteamSpy, incluant :
    -   `owners_range` : plage estimée du nombre de propriétaires du jeu
    -   `playtime_median` : durée médiane de jeu par utilisateur
    -   `concurrent_users_yesterday` : nombre total de joueurs connectés (octobre 2024)
    -   `genres` : catégorie du jeu
    -   `developer` : studio de développement
    -   `publisher` : éditeur du jeu
    
-   **`tags.csv`** : répertorie les tags attribués à chaque jeu (différents des genres).
    
-   **`reviews.csv`** : contient des informations sur les avis des joueurs :
    -   `review_score_description` : évaluation globale (Overwhelmingly Positive, Very Positive, Mixed, etc.)
    -   `positive` / `negative` : nombre d’avis positifs et négatifs
    -   `metacritic_score` : note Metacritic
    -   `recommendations` : nombre de recommandations sur Steam
        
-   **`categories.csv`** : liste les catégories officielles Steam associées aux jeux.

## Plan d'analyse

Nous tenons à éviter de reproduire les mêmes analyses et visualisations que NewbieIndieGameDev disponible sur ce lien :  [Vidéo sur l'analyse des données par NewbieindieGameDev](https://www.youtube.com/watch?v=qiNv3qv-YbU)

Avec ces nombreuses données et variables, de nombreuses pistes d'analyse sont possibles :
- Quels sont les catégories les plus populaire sur Steam?
- Quel est la tendance des jeux sortis récemment ? (genre, jeux indépendants ou AAA, etc...)
- Les avis Metacritics sont-elles corrélées avec les avis données par les joueurs sur la plateforme?