# macdict

Command line interface for built-in offline macOS dictionary (the dictionary used by Dictionary.app).

## Installation

1. Run `make`.
2. (Optional) Put the resulting `dict` executable on your `$PATH`.

## Usage

```
./dict [word]
```

Result printed to standard output:

```text
hel·lo | həˈlō, heˈlō | (also hallo or mainly British hullo) 

exclamation: used as a greeting or to begin a phone conversation: hello there, Katie! • British used to express surprise: hello, what's all this then? • used as a cry to attract someone's attention: “Hello below!” he cried. • expressing sarcasm or anger: Hello! Did you even get what the play was about? 

noun: (plural hellos) an utterance of “hello”; a greeting: she was getting polite nods and hellos from people. 

verb: (helloes, helloing, helloed) [no object] say or shout “hello”; greet someone: I pressed the phone button and helloed. ORIGIN early 19th century: variant of earlier hollo; related to holla. 
```

## Notes

Fun fact: when you read a dictionary entry on the macOS Dictionary.app, you're looking at rendered
HTML! It's just HTML and CSS styling under the hood!

A rough edge: `dict.swift` is hardcoded to look at the "New Oxford American Dictionary". If that's
not available, or not the one you want, consider using the `listDictionaries` function to see what
else is available. I think you could also view the names in Dictionary.app Preferences.

Here are some interesting resources gathered along the way from researching what exists to having
something functional.

1. The more widely known `dict` command to query a dictd server for word definitions is cool, but
   requires either an internet connection or hosting your own dictd server.
2. In terms of offline dictionaries, `sdcv` (StarDict Console Version) seems to be the best option.
   Here's a setup guide: https://askubuntu.com/a/191268 but it's ominous that the offline
   dictionaries have to be downloaded from the depths of the Internet Archive!
   Also note: because of SIP on recent versions of macOS, you cannot install the dictionaries in
   the defualt location `sdcv` expects. Instead you will have to 
   `export STARDICT_DATA_DIR=/usr/local/share/stardict/` and unpack the dictionaries under
   `/usr/local/share/stardict/dic`.
3. One solution would have been to reverse engineer the built-in Apple dictionaries used in
   Dictionary.app. Luckily someone has looked into this before... it doesn't look easy!
   https://josephg.com/blog/reverse-engineering-apple-dictionaries/
4. This incredible article: https://nshipster.com/dictionary-services/ /
   https://github.com/NSHipster/articles/blob/master/2014-03-10-dictionary-services.md
   highlighted that there are some private APIs available from Core Services that are used to
   implement Dictionary.app (dumpy the symbol table for the dictionary executable 
   `nm /System/Applications/Dictionary.app/Contents/MacOS` to see! Things like `DCSRecordCopyData`
   should come up.). With inspiration from https://github.com/jakwings/macdict and a lot of 
   trial and error, I've arrived at the current, not incredibly elegant, but functional enough
   solution.
5. Yes, this is my first experience with Swift. No, I was not super impressed.
   
Enjoy offline definitions in your terminal!

