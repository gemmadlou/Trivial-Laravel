# Laravel Optimized

Example project for CICD optimized Laravel to Kubernetes!

## Development

```bash
docker-compose build

docker-compose up

docker-compose exec app composer install

docker-compose exec app yarn
```

## Production

Build:

```bash
docker-compose -f docker-compose.yml build
```

Test:

```bash
docker-compose -f docker-compose.yml up
```

Publish:

```bash
docker push image:tagname
```
