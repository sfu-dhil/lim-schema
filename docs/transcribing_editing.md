
# Transcribing and Editing Items

Each "piece" in the manuscript is an individual "item," each of which contain their own TEI file in the `/data/` directory under their respective volume numbers. Each `<TEI>` file is named according to the following convention:

* "v" followed by the 2 digit volume number (`v01`, `v10`)
* a period
* The page, following the regularized/idealized version of Forbes' pagination (`0108`, `2142` and not `3042`)
* a period
* The number of the item for that page (almost always `01`, but there can be instances where a single page contains more than a single item

Some examples:

* `data/v01/v01.0189.01.xml`

* `data/v06/v06.1066.02.xml`

* `data/v10/v10.2127.01.xml`

## Item Metadata

The basic principle for all items is that we are describing the metadata as it operates in the text; most interesting, currently, is describing the text in terms of its situational, temporal, and geographic parameters. In other words, whether or not the document itself (or the various documents or other sub-documents exist at all) is unimportant compared to describing how the text functions.

In most cases, that information is fairly minimal, including the page range in Forbes and the page range in Paton. This should be automatically in most cases, but you may need to adjust the end pages (i.e. if the item cross over onto the next page in either one). This is done using the `<locus>` element:

```
<locus type="Paton_vol2" from="12" to="15"/>
<locus type="Forbes" from="125" to="142"/>
```

## Item Content and Transcription

The entire content of the transcription is contained within the `<body>` element of the text. The precise structure of the encoding will depend on the kind of item (letter, poem, et cetera) as well as the particular features of that document, so it is difficult to provide an exact template for encoding the items assembled in Forbes' manuscript. 

### Line Beginnings

Each line of prose within a heading or paragraph must be marked explicitly with the self-closing line-beginning ( `<lb>`) element. Only mark line beginnings within prose (i.e. a paragraph, heading, note, et cetera); new lines between structural elements like paragraphs and headings do not need to be encoded and lines within poems should be encoded according to the documentation on Poetry.

```
 After making Offer of
 <lb/>my Compliments to yourself &amp;
 <lb/>the Leith-Ladies, no Doubt, you 
 <lb/>have heard before now that our
 <lb/>Trials come on the Ninth of Sept.
```

### Page Beginnings

Since we are primarily concerned with the intellectual content of the manuscript, our encoding does not attempt to replicate the exactly layout of the page. Instead, pages are represented by the self-closing `<pb>` element, which does not contain any content itself, but marks the beginning of a new page.

```
Some content on the first page
<pb/>
Some content on the second page
```

The `<pb>` element requires the `@facs` attribute to point to the page that it represents. To point to the page, use the special `pg` prefix, followed by a colon, and the "collection" page number (see [Encoding Facsimiles](facsimilies.md) for documentation on the different kind of page numbers):

```
<pb facs="pg:190"/>
<!--
Content for page 190 here ...
-->

<pb facs="pg:191"/>
<!--
Content for page 191 here ... 
-->
```

Bibliographic features that precede and following page beginnings (catchwords and page numbers) should be encoded using the `<fw>` element. Use the `@type` attribute on to classify the formework (`pageNum` for a page number, `catchword` for a catchword) and the `@place` attribute to describe where it is on the page:

```
<pb facs="pg:190"/>
<fw type="pageNum" place="center">(190)</fw>
```

```
<fw type="catchword" place="right">Reel</fw>
<pb facs="pg:71"/>
<fw type="pageNum" place="center">(71)</fw>
```

Formeworks and page beginnings can appear anywhere in the document, including within paragraphs, et cetera. When a paragraph is split between pages, do not create a new paragraph, but simply encode the formework and page beginning where it happens:

```
               <p><!-- Lines at the beginning of the paragraph...-->
               <lb/>to Miss Mally Clerk, &amp; tell her 
               <lb/>that, notwithstanding of my <w>I<pc force="weak">-</pc>
               <lb/>rons</w> I could dance a highland
               <fw type="catchword" place="right">Reel</fw>
               <pb facs="pg:71"/>
               <fw type="pageNum" place="center">(71)</fw>
               <lb/>Reel with her. Mr Patrick <w>Mur<pc force="weak">-</pc>
               <lb/>ray</w> makes offer of his <w>Compli<pc force="weak">-</pc>
               <lb/>ments</w> to you, &amp; I hope, we'll
               <lb/>meet soon,</p>
```

If the item you're encoding does not start at the beginning of the page (i.e. it begins in the middle of the page), you do not need to have an initial `<pb>` element. 

### End of Line Hyphens

End of line hyphens require special encoding to signal that a) the hyphen is incidental and b) that the word the hyphens splits should be reconsituted when indexed by search engines, etc. 

In all cases, the first step is to tag the hyphen using the `<pc>` element with an `@force`  value of `@weak`, which means that this is a punctuation character that does not break the word.

```
<lb/>the whole will be soon provid<pc force="weak">-</pc>
<lb/>ed. You'll make my Compli<pc force="weak">-</pc>
<lb/>ments to Lady Bruce, &amp; Mr
```

When a word is split across a line, surround the entire word, including the `<pc>` and the `<lb>`, with the `<w>` tag:

```
<lb/>the whole will be soon <w>provid<pc force="weak">-</pc>
<lb/>ed</w>. You'll make my <w>Compli<pc force="weak">-</pc>
<lb/>ments</w> to Lady Bruce, &amp; Mr
```

Words split across a page beginning require more complex encoding, since we must avoid claiming that formeworks are part of the hyphenated word. When a word is split across a page boundary, each part of the word should be enclosed in a `<w>` element that also contains a `@part` attribute; this `@part` attribute should have a value of "I" for the initial part of the word and "F" for the final part of the word.  For example:

```
<lb/>Trumpet &amp; Beat of Kettle-Drums, a <w part="I">Cir<pc force="weak">-</pc></w>
<fw type="catchword" place="right">cumstance</fw>
<pb facs="pg:222"/>
<fw type="pageNum" place="center">(222)</fw>
<lb/><w part="F">cumstance</w> very much noticed by every
```

### Headings

Headings appear at the beginning of an item, usually giving a title ascribed by Forbes. Not all items have headings—most do, but there are notable exceptions, especially in the later volumes of the manuscript. 

To encode the heading of a document, use the `<head>` element:

```
 <head>Copy of a Letter to Mr
    <lb/>Robert Forbes at My Lady
    <lb/>Bruce's Lodgings at Leith.
 </head>

```

Since headings appear inconsistently across the document collection and are often styled differently, any renditional information about the heading (i.e. size or alignment) must be specified using the `@rendition` attribute. For instance, consider the heading for "Copy of a Letter to Mr Robert Forbes at My Lady Bruce's Lodgings at Leith":

![Example from v01.0070.01](images/encoding_heading_example.png)



The heading here is both in larger writing and aligned to the right, which we can describe by using the "rnd:right" and "rnd:large" values on `@rendition`:

```
 <head rendition="rnd:right rnd:large">Copy of a Letter to Mr
    <lb/>Robert Forbes at My Lady
    <lb/>Bruce's Lodgings at Leith.
 </head>
```



### Notes

#### Editorial Notes 

To add an editorial note, use the `<note>` tag with an `@type`=`"editorial"`: 
```
<note type="editorial">An editorially supplied note.</note>
```
 The `@type` is important here: it distinguishes the editorially supplied note from other notes and annotations made by Forbes or later editors.

### Abbreviations and Expansions

#### Common abbreviations: the, that, ampersands

For common abbreviations like "yt" for "that", "ye" for "the" that appear often throughout the text, you do not need to use `<choice>` or `<expan>`; instead, you can simply tag the abbreviation using the `<abbr>` tag with a `@type` value with the correct word:

```
<abbr type="the">ye</abbr>
```

In most cases, ampersands *do not* need to be tagged at all--they will be automatically expanded in processing. However, do note that ampersands are special characters in XML and cannot be represented simply by the & character and must be typed in as `&amp;`

However, if the ampersand does not expand to "and", then you must tag the abbreviation using the full `<choice>`, `<abbr>`, and `<expan>` method below:

```
<choice><abbr>&amp;c.</abbr><expan>et cetera</expan></choice>
```

#### Uncommon abbreviations

Uncommon or unfamiliar abbreviations—like Revd—will often need to be expanded in order to provide clarity and to facilitate searching. To do so, first tag the abbreviation with the `<abbr>` element, then tag your expansion with an `<expan>`, and then wrap both in a `<choice>` element. For example: 

```
<title>Letter from the <choice><abbr>Revd.</abbr><expan>Reverend</expan></choice> Mr. <persName>Lyon</persName></title>
```

### Supplying, Regularizing, and Flagging Incorrect Text

Since the LiM represents multiple voices, we need to be explicit in our signalling of our editorial interventions and judicious in our appraisal of what kind of intervention we need to make.

There are three situations where editorial intervention is necessary:

1. Text that must be supplied due to obscured page images, ink blots, or other obfuscating factors
1. Non-normative spelling that we want to regularize for searching purposes
1. Obvious errors

This list is in order of descending preference; in most cases, it is too difficult to determine if something is truly an "error" that can and should be corrected.

#### Supplying Text

Tag text that has been obscured in some way (usually lost in the margin or the fold of the book) using the `<supplied>` tag:

```
<lb/><supplied>I</supplied>rons upon him, which he looked upon
```
If you are not certain about the supplied text, then use the `@cert` attribute on `<supplied>` with a value of `low`:

```
provided that he
<lb/><supplied cert="low">w</supplied>ould not sit down, but come out as
```

#### Regularizing Text

Tag cases where a word differs from its normative form or spelling and would benefit from regularization to help with searching by tagging the original word using `<orig>`, the regularized version using `<reg>`, and wrapping both in a `<choice>` element:

```
I had some share the effects of <choice><orig>wich</orig><reg>which</reg></choice> 
```

Note that the names of people, places, organizations, and objects *should not* be regularized. Since all people, places, and organizations will be tagged and associated with an person, place, or organization entity, it is unnecessary to regularize these proper names. 

#### Corrections

While we do not correct erroneous text, we do flag instances where the word or phrase seems incorrect in some way by using the `<sic>` tag: 

```
 <lb/>of Distinction, wait <sic>of</sic> General
```

### Additions, Deletions, and Substitutions

Additions and deletions in text may appear in the text either in isolation or as part of a single textual event. 

#### Additions

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

#### Deletions

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

#### Substitutions

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

#### Unclear Text

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

### Foreign Language

To tag that something is in a foreign language, use the `@xml:lang` attribute with an ISO language tag value for that language ( for the list of language tags).

How and where you attach that `@xml:lang` depends on whether the segment of foreign language is entirely contained by a single element. For instance, if an entire `<title>` in an `<item>` is in French, then you can place the `@xml:lang` directly on the `<item>`: 
```
<item><title xml:lang="fr">Le petit chien</title></item>
```
 If the foreign language appears has no logical wrapper (i.e. a single foreign phrase in a sentence or a foreign word), then use the `<foreign>` element: 
```
<item><title>This example was created <foreign xml:lang="la">ex nihilo</foreign></title></item>
```

