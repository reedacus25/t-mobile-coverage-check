# t-mobile-coverage-check
Script to visually parse T-Mobile coverage

This script will scrape the T-Mobile REST API for a given GPS coordinate and return coverage for individual RF bands

Usage:
```
./tmo_coverage.sh 30, -90

GSM coverage:       3
U1900 coverage:     2
U2100 coverage:     0
L2100 coverage:     3
L1900 coverage:     3
L700 coverage:      1
L600 coverage:      1
5G coverage:        3


Signal Legend:
                    1 = Best
                    2 = Good
                    3 = Okay
                    4 = Poor
                    0 = None
```

It requires a latitude argument and a longitude argument.
To make things easier when copy/pasting from Google Maps, the script will strip a trailing comma on the lattitude.

If the point is covered by roaming coverage, it will also provide some data about the roaming coverage as well.

The API has placeholders for 600NSA, 600SA, and 2500NSA coverage values, and they can be uncommented out in the future if they start to provide data.
