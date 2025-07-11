#!/bin/bash

curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

echo "➡️ composer install"
composer install

echo "➡️ $PHPUNIT_COMMAND --coverage-$COVERAGE_FORMAT=coverage.$COVERAGE_FORMAT"
php $PHPUNIT_COMMAND --coverage-$COVERAGE_FORMAT=coverage.$COVERAGE_FORMAT

COVERAGE=$(php -r "\$c = simplexml_load_file('coverage.$COVERAGE_FORMAT'); echo round(\$c->project->metrics['methodscovered'] / \$c->project->metrics['methods'] * 100, 2);")

echo "coverage-percent=$COVERAGE" >> $GITHUB_OUTPUT

echo "➡️ Coverage: $COVERAGE%"

echo "➡️ Generate badge"
echo '<svg xmlns="http://www.w3.org/2000/svg" width="150" height="20">
      <linearGradient id="a" x2="0" y2="100%">
        <stop offset="0" stop-color="#bbb" stop-opacity=".1"/>
        <stop offset="1" stop-opacity=".1"/>
      </linearGradient>
      <rect rx="3" width="150" height="20" fill="#555"/>
      <rect rx="3" x="110" width="40" height="20" fill="#4c1"/>
      <path fill="#4c1" d="M110 0h4v20h-4z"/>
      <rect rx="3" width="150" height="20" fill="url(#a)"/>
      <text x="55" y="15" fill="#fff" text-anchor="middle" font-family="DejaVu Sans,Verdana,Geneva,sans-serif" font-size="11">Methods Coverage</text>
      <text x="130" y="15" fill="#fff" text-anchor="middle" font-family="DejaVu Sans,Verdana,Geneva,sans-serif" font-size="11">'$COVERAGE'</text>
    </svg>' > coverage.svg

echo "➡️ Commit badge"
git config --global user.name "GitHub Actions"
git config --global user.email "actions@github.com"
git add coverage.svg
git commit -m "Update coverage badge"
git push
