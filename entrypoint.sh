#!/bin/bash

curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

echo "composer install"
composer install

echo "$PHPUNIT_COMMAND --coverage-$COVERAGE_FORMAT=coverage.$COVERAGE_FORMAT"
php $PHPUNIT_COMMAND --coverage-$COVERAGE_FORMAT=coverage.$COVERAGE_FORMAT

COVERAGE=$(php -r "\$c = simplexml_load_file('coverage.$COVERAGE_FORMAT'); echo \$c->project->metrics['linecovered'] / \$c->project->metrics['lines'] * 100;")

echo "coverage-percent=$COVERAGE" >> $GITHUB_OUTPUT

echo "Coverage: $COVERAGE%"

npm install -g badge-maker
badge -p "coverage" -v "$COVERAGE%" -c "#4c1" -f coverage.svg

git config --global user.name "GitHub Actions"
git config --global user.email "actions@github.com"
git add coverage.svg
git commit -m "Update coverage badge"
git push
