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

Les datasets sont sous format de différents fichiers csv. Cependant, NewbieIndieGameDev utilisant probablement un logiciel tiers pour
manipuler ses données, certains csv sont mal formattés et imparsables par un programme (données json dans une colonne, balises html, ...). <br>
Nous devons donc les modifier au préalable, nous avons déjà "reformater" le fichier **games.csv** afin de le rendre lisible par nos
programmes et vérifier que nous sommes bien capables de les traiter pour notre projet. <br>
Ainsi dans le dossier data : pour chaque fichier qui possède ce problème, il y aura un fichier **raw_<nom_du_fichier>.csv** qui sont les données brut ("illisibles") et **clean_<nom_du_fichier>.csv** qui sont les données reformater pour qu'elles soient "lisibles".

Ces datasets possèdent de nombreuses variables. Nous allons nous concentrer sur ceux qui nous semblent assez pertinent à analyser.
Description des fichiers et de leur contenu :

-   **`games.csv`** : regroupe les métadonnées des jeux, notamment :
    -   `app_id` (*discrètes*) : identifiant unique du jeu sur Steam
    -   `name` (*nominales*) : titre du jeu
    -   `price` (*continues*) : prix d'achat
    -   `languages` (*nominales*) : les langues disponibles sur le jeu

-   **`steamspy.csv`** : fournit des données issues de SteamSpy, incluant :
    -   `app_id` (*discrètes*) : identifiant unique du jeu sur Steam
    -   `developer` (*nominales*) : studio de développement
    -   `publisher` (*nominales*): éditeur du jeu
    -   `owners_range`(*discretes/continues*) : plage estimée du nombre de propriétaires du jeu
    -   `playtime_median` (*discrètes*) : durée médiane de jeu par utilisateur
    -   `concurrent_users_yesterday` (*discrètes*) : nombre total de joueurs connectés (octobre 2024)
    -   `genres` (*nominales*) : catégorie du jeu

-   **`tags.csv`** : répertorie les tags attribués à chaque jeu (différents des genres).
    -   `app_id` (*discrètes*) : identifiant unique du jeu sur Steam
    -   `tag` (*nominales*) : tag associé au jeu
    
-   **`reviews.csv`** : contient des informations sur les avis des joueurs :
    -   `app_id` (*discrètes*) : identifiant unique du jeu sur Steam
    -   `review_score_description` (*oridnales*) : évaluation globale (Overwhelmingly Positive, Very Positive, Mixed, etc.)
    -   `positive` / `negative` (*nominales*) : nombre d’avis positifs et négatifs
    -   `metacritic_score` (*discrètes*) : note Metacritic
    -   `recommendations` (*discrètes*) : nombre de recommandations sur Steam

-   **`categories.csv`** : liste les catégories officielles Steam associées aux jeux.
    -   `app_id` (*discrètes*) : identifiant unique du jeu sur Steam
    -   `category` (*nominales*) : catégorie associé au jeu

## Plan d'analyse

Nous tenons à éviter de reproduire les mêmes analyses et visualisations que NewbieIndieGameDev disponible sur ce lien :  [Vidéo sur l'analyse des données par NewbieindieGameDev](https://www.youtube.com/watch?v=qiNv3qv-YbU)

Avec ces nombreuses données et variables, de nombreuses pistes d'analyse sont possibles :
### Notes et avis des joueurs
- Une corrélation est-elle identifiable entre les avis/note (Métacritics ou joueurs) et le temps de jeu ?
- Les avis Metacritics sont-elles corrélées avec les avis données par les joueurs sur la plateforme ?
- Voir l'évolution des évaluations des joueurs des jeux AAA
### Genres des jeux
- Quels sont les catégories les plus populaires sur Steam actuellement ?
- Quel est la tendance des jeux sortis récemment ? (genre, jeux indépendants ou AAA, etc...)
- Observer l'évolution des genres de jeu sorties pour déceler des "modes" et période où certains genre de jeux était les plus populaires ?
- À partir des résultats de l'observation précédente essayer de comprendre une montée ou baisse des genres.
  - Exemple (simple) : est-ce que la croissance du genre battle royale peut-être corréler/causé avec la sortie du jeu Fortnite
  - Exemple (complexe) : Peut-on observer une corrélation entre la sortie de jeux en ligne et le déploiement d'internet dans le monde (nécessite de trouver des données sur le déploiement d'internet)
### Jeux indépendants vs AAA
- Les jeux indépendants obtiennent-ils des meilleures évaluations que les AAA ?
- Quelle est la durée de vie d'un jeu indépendant comparée à un AAA? (on essayera de prendre des jeux avec des gerres assez similaires)
- Les genres/tags des jeux indépendants sont-ils plus "innovants" que les AAA ? 
### Prix
- Quels sont les facteurs qui impactent globalement le prix ? (les genres/tags de jeux les plus chers, plus de langues disponibles <=> prix plus chers ?)
### Jeux en ligne
- Quel est les types de jeu en ligne les plus populaires sur Steam ? (FPS, MMO, etc...)
- Déceler certains jeux avec un fort nombre de joueurs connectés et essayez de l'associer à un évènement à ce moment (octobre 2024) qui explique ce nombre élevé : mise à jour conséquente, évènement d'influenceur relançant l'intérêt pour le jeu, etc...
### Différences culturelles/géographique et leurs impacts
- Etudier les langues disponibles selon les jeux des développeurs afin de potentiellement déceler des marchés/régions priorisés.

## Variables à comparer/Visualisations à réaliser
Voici une liste non exhaustive des variables comparées ainsi que les visualisations que l'on va réaliser :
- Nombre de jeux par genre/catégorie, avec possibilité de filtrer par date de sortie pour analyser les tendances récentes.
- Comparaison entre les scores Metacritic et les avis des utilisateurs sur Steam.
- Corrélation entre le nombre de langues disponibles et le nombre de propriétaires d’un jeu.
- Comparaison entre les jeux issus d’un studio indépendant et ceux d’un grand studio, en comparant l’évolution des ventes réalisées, le prix des jeux et les avis des joueurs (ex : les jeux du studio Supergiant Games vs Ubisoft).
- Analyse des combinaisons de genres les plus fréquentes pour les jeux indépendants et les jeux AAA, afin de mettre en évidence des différences de positionnement.
- Évolution des prix de lancement des jeux au fil du temps.

## Problèmes et limitations
- Le dataset que l'on a choisit est un "snapshot" du SteamLibrary datant d'octobre 2024. On ne pourra pas réaliser de comparaisons dans le temps à part dans certains rares cas où les variables nous le permettent (prix initial d'un jeu, etc...)
- Pour certaines données notamment provenant de SteamSpy, ce sont des estimations donc les analyses sur ces données perdront une certaine précision
