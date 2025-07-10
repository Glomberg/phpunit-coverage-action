#!/bin/bash

sudo apt-get update && sudo apt-get install -y php$PHP_VERSION php$PHP_VERSION-xml php$PHP_VERSION-mbstring

curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

composer install --no-progress --no-interaction

php ./vendor/bin/phpunit --coverage-$COVERAGE_FORMAT=coverage.$COVERAGE_FORMAT

COVERAGE=$(php -r "\$c = simplexml_load_file('coverage.$COVERAGE_FORMAT'); echo \$c->project->metrics['linecovered'] / \$c->project->metrics['lines'] * 100;")

echo "Coverage: $COVERAGE%"

npm install -g badge-maker
badge -p "coverage" -v "$COVERAGE%" -c "#4c1" -f coverage.svg

git config --global user.name "GitHub Actions"
git config --global user.email "actions@github.com"
git add coverage.svg
git commit -m "Update coverage badge"
git push
