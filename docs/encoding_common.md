# Common Bibliographical / Structural Features

## Line Beginnings

Each line of prose within a heading or paragraph must be marked explicitly with the self-closing line-beginning ( `<lb>`) element. Only mark line beginnings within prose (i.e. a paragraph, heading, note, et cetera); new lines between structural elements like paragraphs and headings do not need to be encoded and lines within poems should be encoded according to the documentation on Poetry.

```
 After making Offer of
 <lb/>my Compliments to yourself &amp;
 <lb/>the Leith-Ladies, no Doubt, you 
 <lb/>have heard before now that our
 <lb/>Trials come on the Ninth of Sept.
```

## Page Beginnings

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

## Formeworks

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

## End of Line Hyphens

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

## Horizontal Rules

Horizontal rules are lines written in the document that delimit structures and signal some sort of structural shift. These are distinct from underlines and borders and should only be used in cases where the primary function of the line is organizational and not semantic.

To encode these, we use the custom `<rule>` element:

```{=tei}

<specDesc key="rule" 
    atts="unit extent place"/>
```

The `@unit` attribute is mandatory and must be one of either "section" (for all horizontal rules that mark changes in sections) or "item".

Use `unit="section"` when the line separates parts of an item; e.g. the line between a postscript and a signature, et cetera. These should always be between the two structural elements that the line delimits; e.g.:

```
<closer>
<!--[...]-->
</closer>
<rule unit="section"/>
<postscript>
	<p><!--[...]--></p>
</postscript>
```

Encode the line that separates two items (i.e. the final horizontal line at the end of one item) using the `unit="item"` at after the end `<body>` tag; these lines should only be encoded for the item that it ends. 

```
<text>
	<body>
		<!--[ All of the body content for the transcription ]-->
		<signed>R.F</signed>
	</body>
	<rule unit="item"/>
</text>

```

### Styling Horizontal Rules

Given the variation of rules in the manuscript, we do not try to replicate the precise curvature, style, or shape of a given horizontal rule. However, we do capture the length and position of the rule where possible.

If the line separating is significantly shorter than the width of the page, then use the `@extent` attribute to specify a percentange of the page the rule occupies (i.e. 25%, 50%, etc). You do not need to specify `@extent` if the rule spans the width of the page. Shorter rules can also be placed left or right using the `@place` attribute (note that `@place` is only valid if the rule has an `@extent` less than 100%).

```
<rule unit="section" extent="50%" place="right"/>
```

If there are any other stylistic features you think are worth noting, use the `<desc>` element within the `<rule>`:

```
<rule unit="section">
<desc>Line curves around catchword</desc>
</rule>
```

## Source Styling

```{=tei}
<divGen xml:id="rendition_list"/>
```

