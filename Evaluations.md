# TP-1: IaaS deployment

Voici la notice explicative des évaluations à rendre pour le **14-octobre-2020**
Je reste accessible via e-mail, si besoin.

## A propos des évaluations

Les évaluations sont des petits projets (très simples d'abord, et qui gagnent en complexité au fil des évaluations).  
Vous pouvez vous mettre en binôme pour réaliser ces petits projets.

Les petits projets ont tous le même format : fournir une solution **opérationnelle** (i.e. qui fonctionne vraiment) qui tourne dans le _Cloud_ public.  
Cette solution est donc :

* un déploiement et une configuration de services _Cloud_
* intégrés entre eux
* opérationnels
* le déploiement et la configuration étant effectués en _Infra-as-Code_.

Pour éviter un coût trop important de ressources Cloud, et aussi pour vous familiariser avec les notions d'_immutable infrastructure_ et d'environnements éphémères, vous ne fournissez pas **la solution installée**, mais l'**installation automatisée de la solution**.

### Choix du fournisseur de _Cloud_ public

C'est soit `AWS`, soit `Azure`, selon le cas.

* Quand ce n'est pas précisé, vous avez le choix.
* Quand c'est imposé, c'est précisé.

### Notation

Si vous avez travaillé en binôme, les 2 étudiants auront la même note.

* rendu du travail en temps et heure (2 pts)
* clareté et complétude des instructions (3 pts)
* qualité du livrable global : code et résultat (1 pts)
* code opérationnel (5 pts)
* conformité au résultat attendu (5 pts)
* initiative sécurité (2 pts)
* initiative automatisation de la chaîne (5 pts)## Evaluation #1.1: Déployer un site Web statique sur Microsoft Azure


## Evaluation 1.1

### Objectif

Déployer un site _Web_ statique sur `Azure` en utilisant un équivalent à `AWS S3` _Static Web Site_.  
Le contenu du site : _OSEF_. Des pages `index.html` et `error.html` peuvent suffire (mais… cf. la notation, #3).  


### Livrable

Une **unique**  _pull-request_ soumise au présent dépôt `git`.  
Elle doit contenir :

1. un fichier `README.md` avec l'ensemble des informations nécessaires et suffisantes
  * les _pré-requis_  qui ne sont pas inclus dans votre code (par exemple : disposer d'un compte administrateur sur `Azure`, disposer d'un poste de travail avec tel ou tel outil déjà installé, etc.).
  * les instructions pour procéder à l'exécution de votre code
  * la description du résultat qu'on est censé obtenir après exécution de votre code (i.e. le test à faire pour s'assurer que ça fonctionne correctement).
  * les éventuelles difficultés rencontrées
  * le reste à produire (par rapport à la compréhension de l'énoncé ou pour aller plus loin)
1. votre code, proprement structuré et commenté.
  * les outils authorisés sont `Terraform`, `Docker`, le hub Docker, la _CLI_ d'`Azure`, git, et si vous avez du courage, `Travis-CI`.
  * aucune saisie manuelle ne doit être faite.
  * le code doit pouvoir gérer **aussi bien** une installation _from scratch_, qu'une mise à jour du code du site _Web_ (i.e. mise à jour de la page `index.html`, par exemple).

