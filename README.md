## Kidzl

It's [Wordle](https://www.powerlanguage.co.uk/wordle/) but for 4-10 year olds!

Based on the Wordle clone - Hello Wordl, which you can play [**here**](https://hellowordl.net/).

Kidzl however, [**can be played here**](https://Kidzl.xyz/)

## Kidzl (*Flutter's Version*)
The aim here is to transform this project from React into Flutter!

## Introduction

Wordle is a word game similar to the TV show [Lingo](<https://en.wikipedia.org/wiki/Lingo_(British_game_show)>).

In Kidzle you get 10 tries to guess a 3, 4 or 5-letter target word. After each guess, the letters light up in various colors as clues. Green means a letter is correct in this spot; yellow means a letter is _elsewhere_ in the target word; gray means a letter is not in the target word at all. Black keys on the keyboard, mean that letter can not possibly be in the words that will be randomly chosen.

Click _About_ inside the game to learn by example.

Kidzle also differs from the most by having a difficulty slider to select the letters that are in the target words. 
The keybaord changes to reflect only the letters that are used in the target word group, based on levelled sets of words; high frequency and phonemic awareness.
There are 14 difficulty levels in total. Every second step in difficulty, the word list goes from the "basic" word list to also include the "tricky" words from that letter group and any from the lower levels.

For eg. Difficulty level 3.
Only the letters - SATPINCKEHRMD - are included. An example word in this group would be: SAND.
At level 4 the same letters are used, but the target word list is expanded slightly to include options like: HERE.

## A little History 
In 2021, Josh "powerlanguage" Wardle created _Wordle_, a version of the Lingo word game that you can play once a day. The target word is the same for everyone each day, and you can share results to Twitter and compare with your friends. This made Wordle [go absolutely viral](https://www.nytimes.com/2022/01/03/technology/wordle-word-game-creator.html) around January 2022.

My 5 year old saw her parents playing Wordle and wanted to try too, but quickly got frustrated.
I figured, why not try to make a version of Wordle that would appeal to her? A little searching on GitHub found Hello Wordl, a really good interpretaton of Wordle made with the intention of being able to play more than once a day. The creator just so happens to have made it open to modification, so that is what I (with some help from a frined) used as a basis to edit - and Kidzl is what we get as a result.

My hope is that this can be something for students or teachers to use in the class room or at home as a fun way of practicing some basic phonics and spelling.

The share options include links to share the exact game that is played, same target word, same difficulty slider (available letters) showing ont he keyboard. 
Maybe it could be used to send the link to a class room full of kids to try out at home and share back with the class their Emojii results?

## Where are the words coming from?

The target word groups are based on levelled sets of words factoring high frequency and phonemic awareness. 
The JollyPhonics.json file in the code is used as the target word list. The name of that file should give an idea where the bulk of the target word list was sourced from.

## My word contained two of the same letter!

This can happen in Wordle too, clues are given the same way Wordle does.




## For developers

You're very welcome to create your own Wordle / Kidzl offshoot/remix based on _hello wordl_. To get started, you can [fork the code](https://docs.github.com/en/get-started/quickstart/fork-a-repo) on GitHub.

To run the code locally, first install [Node.js and npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm#using-a-node-version-manager-to-install-nodejs-and-npm). Then, in this directory, open a terminal and run `npm install` followed by `npm run start`. _hello wordl_ will be running at http://localhost:3000/. Any changes you make to the source code will be reflected there. Have fun!

Finally, `npm run deploy` will deploy your code to the `gh-pages` branch of your fork, so that everyone can play your version at https://yourname.github.io/hello-wordl (or the name of your fork if you renamed it). 
