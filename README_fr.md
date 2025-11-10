

# Questions

## 1. Question 1
La première étape consistera à créer un fichier YAML Cloud Build, qui détermine les étapes nécessaires pour construire notre image Docker et la pousser vers l'Artifact Registry.

### Création d'un fichier YAML Cloud Build
Construisez un fichier YAML Cloud Build en utilisant le fichier `deployment/cloudbuild_template.yaml` comme modèle.

Dans ce fichier, nous allons utiliser des substitutions pour remplir les valeurs correctes. Les substitutions permettent de passer des variables dans le processus de build.

En regardant `deployment/submit_build_template.sh`, les substitutions suivantes sont disponibles :
- `_BASE_IMAGE_URI`
- `_APP_URI` (l'URI de l'image que nous construisons)
- `_SERVING_PORT`
- `_DOCKERFILE`

qui peuvent être référencées sous la forme `${SUBSTITUTION_NAME}` dans votre fichier YAML.

Il y a également `${BUILD_ID}` qui est une variable d'environnement présente dans Google Cloud Build et qui contient la valeur de l'identifiant de build unique actuel.

Vous devrez remplir les valeurs correctes pour vous assurer que ces substitutions sont correctes. Voir `#FILL ME IN` dans le fichier `deployment/submit_build_template.sh`.

Suivez les instructions dans `deployment/cloudbuild_template.yaml` pour créer un fichier YAML Cloud Build qui construira et poussera notre image Docker.

Dans le fichier Cloud Build, nous construisons deux images :
- Une image de "base" contenant toutes nos dépendances.
- Une deuxième image qui est construite à partir de notre image de base et qui installe notre code.
Nous explorerons pourquoi dans la question suivante.

Plus d'informations sur la création d'un fichier YAML Cloud Build se trouvent [ici](https://cloud.google.com/build/docs/configuring-builds/create-basic-configuration).

**ASTUCE :** Assurez-vous de lire et comprendre les fichiers Docker que vous construisez. Ces fichiers Docker utilisent l'instruction `ARG`, qui vous obligera à passer les bonnes valeurs lors de la soumission du build. Voir [Build Variables](https://docs.docker.com/build/building/variables/) pour plus d'informations.

### Soumission du build à Cloud Build
Une fois que vous avez créé le fichier Cloud Build, utilisez la commande `gcloud` pour soumettre le build à Cloud Build. Vous pouvez utiliser le fichier `submit_build_template.sh` pour cela. Plus de documentation sur `gcloud builds` se trouve [ici](https://cloud.google.com/sdk/gcloud/reference/builds/submit).

Lorsque vous exécutez le script, vous verrez les logs s'afficher dans le terminal. `gcloud` vous donnera également un lien pour visualiser le build dans votre navigateur. Vous pouvez consulter tous vos builds [ici](https://console.cloud.google.com/cloud-build/builds).

### Livrables
Pour cette question, vous devez soumettre les fichiers suivants :
- 1 fichier YAML Cloud Build.
- 1 script de soumission de build.
- Fichier `deliverables.yaml` avec les identifiants de build pour les builds du backend et du frontend.

## 2. Question 2
Combien d'images sont construites à chaque fois que vous soumettez un build ?
Cela doit-il toujours être le cas ? Pourquoi ou pourquoi pas ?
Si non, comment pourriez-vous accélérer le processus de build ?
Ajoutez une étape au début de vos fichiers Cloud Build pour résoudre cette inefficacité.

**Indice :** Voir [Meilleures pratiques pour accélérer les builds](https://cloud.google.com/build/docs/optimize-builds/speeding-up-builds).

## 3. Question 3
Une fois que nous avons construit et poussé nos images Docker, nous pouvons les déployer en utilisant le service Google Cloud Run.
Cette question se concentre sur le déploiement des services `backend_v1` et `frontend_v1`. Tous vos services Google Cloud Run peuvent être consultés [ici](https://console.cloud.google.com/run).

Vous pouvez utiliser le fichier `deployment/deploy_service_template.sh` pour commencer.

Lorsque vous déployez votre service frontend, assurez-vous de spécifier une variable d'environnement, `SERVING_URL`, qui est l'URL du service backend.

Vous devrez également connaître l'URI de l'image que vous souhaitez déployer. Vous pouvez les trouver dans l'Artifact Registry, situé [ici](https://console.cloud.google.com/artifacts). Cela devrait ressembler à ceci :

![](_assets/artifact_registry.png)

En cliquant sur les trois points à côté de l'image souhaitée, et en sélectionnant "Afficher la commande de pull", vous pouvez obtenir l'URI complet de l'image.

Une fois que vous exécutez le script, vous verrez l'URL du service déployé dans le terminal. Chaque service (frontend et backend) aura une URL différente. Une fois que les deux services sont déployés, vous pouvez les tester en accédant à l'URL du frontend et en téléchargeant une image.

Incluez deux scripts dans votre soumission :
- `deploy_backend_v1.sh`
- `deploy_frontend_v1.sh`
- Incluez l'URL du service déployé dans `deliverables.yaml`.

## 4. Question 4
Lorsque `backend_v1` est déployé, vous remarquerez dans les logs qu'il télécharge le modèle ResNet depuis le hub PyTorch. Cela prendra du temps.

Quelles sont les façons de contourner cela ?
Cela affectera-t-il le processus de build ? Si oui, comment ?

## 5. Question 5
Nous avons déployé les services backend et frontend séparément.
Quels sont les avantages et les inconvénients de cette approche ?

## 6. Question 6
Déployez les services `backend_v2` et `frontend_v2` en créant deux nouveaux services Cloud Run : `backend_v2` et `frontend_v2`.

Lorsque vous déployez votre service frontend, assurez-vous de spécifier une variable d'environnement, `SERVING_URL`, qui est l'URL du service backend.

Vous pouvez utiliser le fichier `deploy_service_template.sh` pour commencer.
Incluez deux scripts dans votre soumission :
- `deploy_backend_v2.sh`
- `deploy_frontend_v2.sh`
- Incluez l'URL du service déployé dans `deliverables.yaml`.

Dans cette application, nous pourrons sélectionner différents modèles à utiliser pour la classification.

## 7. Question 7
Si vous regardez `backend_v1/app.py` et `backend_v2/app.py`, vous verrez que les modèles sont chargés dans une variable globale appelée `model`.

Dans le cas de notre application `v1`, pourquoi cela n'est-il pas vraiment un problème ?
Dans `v2`, pourquoi est-ce un problème (Indice : que se passe-t-il si deux personnes utilisent l'interface en même temps) ?

Que devrions-nous modifier pour corriger cela ?
- Dans le frontend ? (Indice : Lisez [cet article](https://testdriven.io/blog/flask-sessions/))
- Dans le backend ?
    - Indice : Quelles sont les implications de charger le modèle choisi à chaque requête ? Avoir plusieurs modèles dans le même conteneur est-il une bonne idée ? Pourquoi ou pourquoi pas ?

## 8. Question 8
Inspectez le code dans `v3/`. Vous n'avez pas besoin de le construire et de le déployer (en fait, certaines parties sont incomplètes). Qu'essaie-t-il d'accomplir ? En quoi est-il différent des versions précédentes ? (Indice : Qu'est-ce qu'une passerelle API ?)

### 9. Question 9
"La quantification est le processus de réduction de la précision d'un signal numérique, généralement d'un format à haute précision à un format à plus faible précision. Cette technique est largement utilisée dans divers domaines, notamment le traitement du signal, la compression de données et le machine learning" ([source](https://www.ibm.com/think/topics/quantization)).

Quels sont les avantages et les inconvénients de l'utilisation de la quantification en ce qui concerne l'inférence de modèles ?

**Vous devez citer toutes les sources utilisées pour répondre à cette question.**
