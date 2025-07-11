# Docker PHP for Symfony

Optimized Docker image for pipeline of Symfony projects with PHP.

## Usage

```bash
docker build -t enabel/pipeline-php:8.4 .
docker run --rm -it -v $(pwd):/var/www/html enabel/pipeline-php:8.4 bash
```

## Installed extensions

- intl
- pdo
- pdo_mysql
- opcache
- zip
- gd
- redis
- xsl
- xdebug
- pcov

## Composer

Composer is already included in the image.

## Symfony CLI

Symfony CLI is pre-installed for easier project management.

## For Azure DevOps

Use this image in your pipelines to build, test, and deploy your Symfony projects.

## Base

This image is based on [php:8.4-cli](https://hub.docker.com/_/php) to ensure optimal performance.

## License

MIT

## About
Originally designed by [Damien Lagae][1]. If you have any questions, please contact [Damien Lagae][1].

[1]: damien.lagae@enabel.be
