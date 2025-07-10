const { makeBadge } = require('badge-maker');
const fs = require('fs');

const coverage = process.argv[2] || '0';
const color = coverage >= 90 ? 'brightgreen' : coverage >= 70 ? 'yellow' : 'red';

const svg = makeBadge({
    label: 'coverage',
    message: `${coverage}%`,
    color: color,
});

fs.writeFileSync('coverage.svg', svg);
