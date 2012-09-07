module Creative::Machine
  class SyllableExtractor

    # Syllables Rules:
    # A syllable is the sound of a vowel (a, e, i, o, u) that's created when pronouncing a word.
    # The number of times that you hear the sound of a vowel (a, e, i, o, u) in a word is equal to the number of syllables the word has.
    # 
    # How To Find Syllables:
    # 
    # Count the number of vowels (a, e, i, o, u, and sometimes y) in the word.
    # Subtract any silent vowels (like the silent 'e' at the end of a word).
    # Subtract 1 vowel from every diphthong.
    # A diphthong is when two volwels make only 1 sound (oi, oy, ou, ow, au, aw, oo, ...).
    # The number you are left with should be the number of vowels in the word.
    # How To Divide A Word Into Syllables:
    # Divide off any compound words, prefixes, suffixes, and root words that have vowels.
    # sports/car, house/boat, un/happy, pre/paid, re/write, farm/er, hope/less
    # Divide between two middle consonants
    # hap/pens, bas/ket, let/ter, sup/per, din/ner
    # Never split up consonant digraphs as they really represent only one sound ("th", "sh", "ph", "th", "ch", and "wh").
    # Usually divide before a single consonant.
    # o/pen, i/tem, e/vil, re/port.
    # The only exceptions are those times when the first syllable has an obvious short sound, as in "cab/in".
    # Divide before an "-le" syllable.
    # a/ble, fum/ble, rub/ble, mum/ble
    # The only exceptions are "ckle" words like "tick/le".

    def self.extract(word)
      
    end
    
  end
end