# Docker PHP 8.4 pour Symfony

Image Docker optimisée pour les projets Symfony avec PHP 8.4.

## Utilisation

```bash
docker build -t symfony-php:8.4 .
docker run --rm -it -v $(pwd):/var/www/html symfony-php:8.4 bash
```

## Extensions installées

- intl
- pdo
- pdo_mysql
- opcache
- zip
- gd

## Composer

Composer est déjà inclus dans l’image.

## Pour Azure DevOps

Utilisez cette image dans vos pipelines pour builder, tester et déployer vos projets Symfony.

## Licence

MIT
