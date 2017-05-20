== README

Ruby-Rails app to solve a word puzzle which appears in newspapers frequently:
* Take 1+6 different letters of the alphabet
* Find words of length 5 or greater, using only these 1+6 letters
* The first ("1") letter must be used
* Letters can be repeated with no restrictions
* Scoring: 3 points for words which use all 1+6 letters, otherwise 1 point

Examples:
* F+ULVNET
* P+AIURTY

# Under the Hood

This is a minimal Rails app, and deploys to Heorku easily.

## Environments

There are two word dictionaries: one for dev+test, and one for production.  The dev+test dictionary is limited so as not to slow down a person performing units tests or frequent startups.  The production dictionary is large and takes a bit to load into the cache.  There are two ways to point to the desired dictionary:
* RAILS_ENV environment variable: when this is set to 'production', the full dictionary is used.  Otherwise the dev_test dictionary is used.
* PUZZLE_DICT environment variable: this will override the first bullet's logic.  Set this to either 'words.txt' or 'words_dev.txt'

## Tests
```
rspec -fd spec/ 
```

