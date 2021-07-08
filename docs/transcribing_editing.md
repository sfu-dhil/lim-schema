
# Transcribing and Editing

The following instructions apply to all editorial changes made to a text; this includes features like editorial notes, expanding abbreviations, correction of spelling, or supplying clarifying text.

## Adding Editorial Notes

To add an editorial note, use the `<note>` tag with an `@type`=`"editorial"`: 
```
<note type="editorial">An editorially supplied note.</note>
```
 The `@type` is important here: it distinguishes the editorially supplied note from other notes and annotations made by Forbes or later editors.

## Abbreviations and Expansions

Uncommon or unfamiliar abbreviations—like Revt—will often need to be expanded in order to provide clarity and to facilitate searching. To do so, first tag the abbreviation with the `<abbr>` element, then tag your expansion with an `<expan>`, and then wrap both in a `<choice>` element. For example: 
```
<title>Letter from the <choice><abbr>Revt.</abbr><expan>Reverend</expan></choice> Mr. <persName>Lyon</persName></title>
```


The `<choice>` element is known in TEI-speak as a Janus element: it always contains two elements—one original, and one editorially supplied.

## Corrections

Correcting erronous text follows a similar protocol: use the `<sic>` element to tag the original error and a `<corr>` for the correction, wrapping both in a `<choice>`: 
```
<choice><sic>acount</sic><corr>account</corr></choice>
```


## Uncertainty

If you are uncertain about either an expansion or a correction, use the `@cert` attribute with a value of "low", "medium", or "high" to flag uncertainty about your editorial emendation: 
```
<choice><sic>acount</sic><corr cert="low">a count</corr></choice>
```


## Unclear Text

Tag text that you are unable to transcribe text that is partially obscured for some reason (illegible writing, scan is missing or incompletel, external damage like ink smudges, etc) using the `<unclear>` element: 
```
<unclear>MacDonald</unclear>
```
 If you'd like to expand on what is unclear, or possible other readings, then add a note beside the `<unclear>` using the `<note>` element with `@type`=`"editorial"` 
```
<unclear>MacDonald</unclear> <note type="editorial">Quite likely MacDonald, but could also be McDonald.</note>
```


If you are unable to transcribe the text at all or the text has been removed completely (i.e. the page is burnt; the text is cut off in the facsimile), use the `<gap>` element with an explanatory `<desc>`: 
```
<gap><desc>First six words illegible due to scan.</desc></gap>
```


## Deletions

Tag text that has been marked for deleting using the `<del>` element: 
```
<title>Written in <del>in</del> April</title>
```
 If the deletion has obscured the text such that it makes the text difficult (but not impossible) to transcribe, nest the `<unclear>` tag within the `<del>`; as above, add an editorial note if warrants further explanation or clarification is needed (note, however, that the `<note>` is beside the `<del>` element): 
```
<title>While I pondered weak and <del><unclear>wary</unclear></del><note type="editorial">Possibly <mentioned>weary</mentioned>.</note></title>
```


If the text is rendered completely illegible, then use a `<gap>` element with an explanatory `<desc>` within the `<del>`: 
```
<title>While I pondered weak and <del><gap><desc>Illegible</desc></gap></del></title>
```


## Foreign Language

To tag that something is in a foreign language, use the `@xml:lang` attribute with an ISO language tag value for that language ( for the list of language tags).

How and where you attach that `@xml:lang` depends on whether the segment of foreign language is entirely contained by a single element. For instance, if an entire `<title>` in an `<item>` is in French, then you can place the `@xml:lang` directly on the `<item>`: 
```
<item><title xml:lang="fr">Le petit chien</title></item>
```
 If the foreign language appears has no logical wrapper (i.e. a single foreign phrase in a sentence or a foreign word), then use the `<foreign>` element: 
```
<item><title>This example was created <foreign xml:lang="la">ex nihilo</foreign></title></item>
```

