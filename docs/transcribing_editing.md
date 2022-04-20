
# Transcribing and Editing

The following instructions apply to all editorial changes made to a text; this includes features like editorial notes, expanding abbreviations, correction of spelling, or supplying clarifying text.

## Adding Editorial Notes

To add an editorial note, use the `<note>` tag with an `@type`=`"editorial"`: 
```
<note type="editorial">An editorially supplied note.</note>
```
 The `@type` is important here: it distinguishes the editorially supplied note from other notes and annotations made by Forbes or later editors.
 
## Adding Marginal Notes

Here is the documentation for adding marginal notes. 

```
<note type="marginal" place="margin">This is the marginal note</note>
```

## Abbreviations and Expansions

In the project, we have two methods for encoding abbreviations.

### Uncommon abbreviations


Uncommon or unfamiliar abbreviations—like Revd—will often need to be expanded in order to provide clarity and to facilitate searching. To do so, first tag the abbreviation with the `<abbr>` element, then tag your expansion with an `<expan>`, and then wrap both in a `<choice>` element. For example: 

```
<title>Letter from the <choice><abbr>Revd.</abbr><expan>Reverend</expan></choice> Mr. <persName>Lyon</persName></title>
```


### Common abbreviations: the, that, ampersands

For common abbreviations like "yt" for "that", "ye" for "the" that appear often throughout the text, you do not need to use `<choice>` or `<expan>`; instead, you can simply tag the abbreviation using the `<abbr>` tag with a `@type` value with the correct word:

```
<abbr type="the">ye</abbr>
```

In most cases, ampersands *do not* need to be tagged at all--they will be automatically expanded in processing. However, do note that ampersands are special characters in XML and cannot be represented simply by the & character and must be typed in as `&amp;`

However, if the ampersand does not expand to "and", then you must tag the abbreviation using the full `<choice>`, `<abbr>`, and `<expan>` method above:

```
<choice><abbr>&amp;c.</abbr><expan>et cetera</expan></choice>
```


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


## Additions, Deletions, and Substitutions

Additions and deletions in text may appear in the text either in isolation or as part of a single textual event. 

### Additions

In all cases, additions should be marked with the `<add>` tag with its location encoded using the `@place` attribute. For example:

![Example from v02.0221.01](images/addition_example.png)

In this case, text has been added above the line, which would be encoded like so: 

```
<lb/>Donell, <add place="above">George Moir the</add> Laird of Leckie,
```

Here, we can also tag the "George Moir the Laird of Leckie" as a `<persName>` and point to his `@xml:id`:

```
<lb/>Donell, <persName ref="prs:MOIRG1"><add place="above">George Moir the</add> Laird of Leckie</persName>
```

### Deletions

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

### Substitutions

When an addition and deletion are related (i.e. the additional text should take the place of the deleted text), then we can encode that relationship by wrapping the `<add>` and `<del>` with the substitution element `<subst>`. For example:

![Example from v02.0221.01](images/substitution_example.png)

The substitions are highlighted above; in each case, there is a deletion (with illegible content) and an addition above. In the first example, we would encode the additional "some" using the `add` element:

```
<add place="above">some</add>
```
and the deleted word using `<del>` with a nested `<gap>` that examples the extent of the cancelled text:

```
<del><gap reason="deleted" quantity="1" unit="word"/></del>
```

To signal that these are a related substitution, we wrap the `add` and the `del` in a `<subst>`. So putting this all together:

```
<subst><add place="above">some</add><del><gap reason="deleted" quantity="1" unit="word"/></del></subst>
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


