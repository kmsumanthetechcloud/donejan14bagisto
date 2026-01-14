docker exec -it bagisto_app php artisan key:generate
docker exec -it bagisto_app php artisan migrate --seed
docker exec -it bagisto_app php artisan storage:link
docker exec -it bagisto_app php artisan optimize:clear


docker compose up --build -d
