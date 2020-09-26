# TP-1: IaaS deployment
Les cours et les TPs correspondant aux sessions 2020 du cours « Cloud et Infrastructure »

## Objectifs 🎯

Découverte du Cloud AWS, navigation dans la console Web.
Découverte des principales ressources `AWS`
Découverte des outils de manipulation _as-code_
Premiers déploiements simples dans `AWS`

## Déroulé 🎢

:bulb:
Premières manipulations dans AWS, console Web, ligne de commande et _infra-as-code_.

1. Création de compte **AWS**
1. Tour d'horizon de la _WebUI_
  * les principaux services **AWS** d'_IaaS_
1. Découverte de AWS Simple Storage Server
  * Création d'un bucket
  * Dépose de fichiers dans le bucket
  * Déploiement d'un site Web statique sur `AWS S3`

### Utilisation de la ligne de commande `aws` pour faire une mise à jour du site

**AWS** fournit un outil en ligne de commande pour manipuler les ressources du _Cloud_ `AWS` sans recourir à la console _Web_ 

#### de l'importance de bien s'outiller : tour d'horizon de l'image docker utilisée

L'installation de `AWS cli` est lourde et lente.  
La doc est ici : https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html  
Le travail est fait pour vous : tout a été packagé dans une image `Docker` que l'on va utiliser en mode interactif.

```shell
docker container run -it --name monlab --volume $(pwd):/code thegaragebandofit:
```

```shell
root@d5129bd0f5a2:/# aws configure
AWS Access Key ID [None]:     xxxxxx
AWS Secret Access Key [None]: ******
Default region name [None]:   eu-west-1
Default output format [None]: json
```

Regardons un peu ce que l'on peut faire avec cette _cli_…

```shell
root@d5129bd0f5a2:/# aws s3 ls
2020-09-25 17:29:05 lpiot-monsite
2020-09-26 11:38:14 lpiot-test-7890
2020-04-17 19:59:16 lpiot-toto
root@d5129bd0f5a2:/# aws s3 ls s3://lpiot-monsite
2020-09-25 17:27:41         42 error.html
2020-09-26 13:44:20        467 index.html
```

Essayons de déposer un nouveau fichier dans ce _bucket_.

```shell
root@d5129bd0f5a2:/code/resources/# aws s3 cp error.html s3://lpiot-monsite/
upload: ./error.html to s3://lpiot-monsite/error.html    
```

Créons un nouveau _bucket_ `AWS S3` nommé `lpiot-test-7890`…

```shell
root@d5129bd0f5a2:/code/resources/# aws s3api create-bucket --bucket lpiot-test-7890 --region us-east-1
{
    "Location": "/lpiot-test-7890"
    }
```

Tentons d'en voir les fichiers à travers des requêtes `HTTP`…
```shell
root@d5129bd0f5a2:/code/resources/# curl http://lpiot-test-7890.s3-website.us-east-1.amazonaws.com/error.html
<html>
<head><title>404 Not Found</title></head>
<body>
<h1>404 Not Found</h1>
<ul>
<li>Code: NoSuchWebsiteConfiguration</li>
<li>Message: The specified bucket does not have a website configuration</li>
<li>BucketName: lpiot-test-7890</li>
<li>RequestId: F7771FFFAE720F09</li>
<li>HostId: uKxu9sKqLSG4NaPNGv5uM5kAgbCsF6nQGHzVKV4ms+gVBKiUvC6imMXEQrkeeXUkSqk2Fgi3y7c=</li>
</ul>
<hr/>
</body>
</html>
```

Le _bucket_ n'est pas exposé en tant que site _Web_.
Il faut le configurer pour cela.

```shell
root@d5129bd0f5a2:/code/resources/# aws s3 website s3://lpiot-test-7890/ --index-document index.html --error-document error.html
root@d5129bd0f5a2:/code/resources/# 
```

On copie les fichiers dans le _bucket_…
```shell
root@d5129bd0f5a2:/code/resources/# aws s3 sync . s3://lpiot-test-7890/ --acl public-read
upload: ./error.html to s3://lpiot-test-7890/error.html
upload: ./test.txt to s3://lpiot-test-7890/test.txt
upload: ./index.html to s3://lpiot-test-7890/index.html
```

Si on tente à nouveau de requêter…  
On a bien le résultat attendu.

```shell
root@d5129bd0f5a2:/code/resources/# curl http://lpiot-test-7890.s3-website.us-east-1.amazonaws.com/index.html
<html>
  <head>
    Content-Type: text/plain; charset=utf-8
  </head>
  <body>
    __  __________    __    ____     _       ______  ____  __    ____  __
   / / / / ____/ /   / /   / __ \   | |     / / __ \/ __ \/ /   / __ \/ /
  / /_/ / __/ / /   / /   / / / /   | | /| / / / / / /_/ / /   / / / / / 
 / __  / /___/ /___/ /___/ /_/ /    | |/ |/ / /_/ / _, _/ /___/ /_/ /_/  
/_/ /_/_____/_____/_____/\____/     |__/|__/\____/_/ |_/_____/_____(_)   
  </body>
</html>

root@d5129bd0f5a2:/code/resources/# curl http://lpiot-test-7890.s3-website.us-east-1.amazonaws.com/error.html
<html>
  <head>
    Content-Type: text/plain; charset=utf-8
  </head>
  <body>
    _________  _________    __       __________  ____  ____  ____ 
   / ____/   |/_  __/   |  / /      / ____/ __ \/ __ \/ __ \/ __ \
  / /_  / /| | / / / /| | / /      / __/ / /_/ / /_/ / / / / /_/ /
 / __/ / ___ |/ / / ___ |/ /___   / /___/ _, _/ _, _/ /_/ / _, _/ 
/_/   /_/  |_/_/ /_/  |_/_____/  /_____/_/ |_/_/ |_|\____/_/ |_|  
  </body>
</html>

root@d5129bd0f5a2:/code/resources/# curl http://lpiot-test-7890.s3-website.us-east-1.amazonaws.com/test.txt
  _______________________
 /_  __/ ____/ ___/_  __/
  / / / __/  \__ \ / /   
 / / / /___ ___/ // /    
/_/ /_____//____//_/     

```

Revoyons les ACL du fichier `test.txt`…

```shell
root@d5129bd0f5a2:/code/resources/# aws s3 cp s3://lpiot-test-7890/test.txt s3://lpiot-test-7890/test2.txt
copy: s3://lpiot-test-7890/test.txt to s3://lpiot-test-7890/test2.txt
```

Requêtons à nouveau nos fichiers…

```shell
root@d5129bd0f5a2:/code/resources/# curl http://lpiot-test-7890.s3-website.us-east-1.amazonaws.com/test2.txt
<html>
  <head>
    Content-Type: text/plain; charset=utf-8
  </head>
  <body>
    _________  _________    __       __________  ____  ____  ____ 
   / ____/   |/_  __/   |  / /      / ____/ __ \/ __ \/ __ \/ __ \
  / /_  / /| | / / / /| | / /      / __/ / /_/ / /_/ / / / / /_/ /
 / __/ / ___ |/ / / ___ |/ /___   / /___/ _, _/ _, _/ /_/ / _, _/ 
/_/   /_/  |_/_/ /_/  |_/_____/  /_____/_/ |_/_/ |_|\____/_/ |_|  
  </body>
</html>

root@d5129bd0f5a2:/code/resources/# curl http://lpiot-test-7890.s3-website.us-east-1.amazonaws.com/test.txt
  _______________________
 /_  __/ ____/ ___/_  __/
  / / / __/  \__ \ / /   
 / / / /___ ___/ // /    
/_/ /_____//____//_/     
```

Le fichier `test2.txt` n'a pas hérité des _ACL_ du fichier source !


1. Introduction à `Terraform`
* un tour d'horizon de CloudFormation, Boto…
* 1er déploiement en _infra-as-code_
    * notion de provider
    * compte de service IAM, secret_key et 

Topologie réseau
Security groups
IAM

### Introduction à Packer

* Construction d'une _golden AMI_.


