import json, random, sys

PATH = "./SATWordShared/Resources/sat_words.json"

def randomize_words():
    with open(PATH, 'r') as file:
        words = json.load(file)

    random.shuffle(words)


    with open(PATH, 'w') as file:
        json.dump(words, file, indent=4)

def unrandomize_words():
    with open(PATH, 'r') as file:
        words = json.load(file)

    words.sort(key=lambda x: x['word'])

    for d in words:
        d["isKnown"] = False

    with open(PATH, 'w') as file:
        json.dump(words, file, indent=4)

# unrandomize if any arg is given
if len(sys.argv) == 1:
    print("Randomizing words...")
    randomize_words()
else:
    print("Unrandomizing words...")
    unrandomize_words()

