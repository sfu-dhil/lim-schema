# Notes and Annotations

Notes and annotations refer to any kind of textual component that serve as, or cause, some sort of intervention within the main flow of the text, appearing virtually anywhere through the document. Often, notes are used by Forbes (or others) to provide some additional hypertextual information to supplement that main text; this is in contrast to [additions and deletions](transcribing_edition.md) (tagged using `<add>` and `<del>`), which modify the main content of the text.

This page describes how to encode notes that appear within the primary source text and not notes written by the LiM team (see [Editorial Notes](#editorial_notes) for instructions on encoding editorial notes). In all cases, we use the `<note>` element for encoding the main content of the note with a `@type` value of "lim." Further information on other attributes used to differentiate the placement, position, and function of these notes are described in the following.

## Note Content

All notes must have _structured content_, meaning that it must contain, at minimum, a child `<p>` element. This is not a required by the TEI, but makes processing and handling for the note much more straightforward. (This decision, and much of the modelling for notes, has been inspired by _The Women Writers Project's Guide to Scholarly Text Encoding_, especially their discussion of ["Notes and Annotations"](https://wwp.northeastern.edu/research/publications/guide/html/notes_outline.html))

In most cases, this means that even a short note--like a cross-reference--will contain a paragraph:

```
<note type="lim" place="above">
<p>See p. <ref target="pg:524">524</ref>.</p>
</note>

```

ALl other transcribing conventions apply within a `<note>`; if there are page beginnings or formeworks, encode those as you would normally. 


## Footnotes

The most common kind of note in Forbes is a footnote, which consists of three things:

1. A note marker in the text (e.g. a cross)
1. A corresponding marker found elsewhere that refers to the one in the text
1. The content of the annotation

Our encoding of these notes is to make the relationship between the note and the text explicit by providing links between the note marker in the text with the note itself. 

### Encoding the note marker

Note markers found within the text (i.e. the symbol that refers to the note) are tagged using the custom `<noteMarker>` element, bearing an `@xml:id` and a `@ref`:

```{=tei}
<specList>
    <specDesc key="noteMarker" atts="xml:id ref"/>
</specList>
```
In the majority of cases, the `<noteMarker>` will have no content (i.e. it is a self-closing element: `<noteMarker/>`); to describe the symbol (or "glyph"), use the `@ref` attribute to point to the centralized definition of the glyphs we have compiled. The list of available glyphs is below:

```{=tei}
<divGen xml:id="glyph_list"/>
```
In this case, the symbol is a cross, so it would be encoded like so:

```
<noteMarker ref="g:cross"/>
```

If the symbol you're attempting to encode is not on the list, use the value `g:UNKNOWN` in the `@ref` and then place the best approximation of the symbol you can find inside of the `<noteMarker>` element:

```
<noteMarker ref="g:UNKNOWN">☃</noteMarker>
```

Put a (initialed) XML comment inside of the noteMarker element as well to describe to future encoders what you found; we will want to add this symbol to our list of glyphs as we proceed:

```
<noteMarker ref="g:UNKNOWN">☃<!--JT: Forbes used a snowman, for some reason?--></noteMarker>
```

Note markers must also contain a unique identifier using the `@xml:id` attribute. The `@xml:id` should being with a "p", followed by the page number, an underscore, an "n", and a number. For example:

```
<noteMarker ref="g:cross" xml:id="p242_n1"/>
```

### Encoding the Note

Encode the content of the note as it appears on the page. Usually, this is at the bottom of the page either preceding or following the catchword; notes tend to be grouped together at the bottom of the page and separated from the main content with a horizontal line, which should be encoded  according to [Common Bibliographical/Structural Features](encoding_common.md#encoding_common_horizontal-rules). 

Footnotes should be tagged using a `<note>` element with a `@type` = "lim" and `@anchored` = "true".

```
<milestone unit="section" type="rule"/>
<note type="lim" anchored="true">
<!--Note content...-->

</note>
```

All anchored notes must begin with a `<noteMarker>` with a `@target` attribute that points to the id (or ids) of the note markers you encoded earlier. In XML, you can point to an id by first putting a '#' and then the id. For instance, in the above example, the cross has an `@xml:id` = "p242_n1". For the corresponding note, we do the following:

```
<note type="lim" anchored="true">
<noteMarker ref="g:cross" target="#p242_n1"/>
<!--More content here-->
</note>
```

Make sure to use the same `@ref` value from the earlier note (and, if the value was `g:UNKNOWN`, then place the same content inside of the `<noteMarker>`).

In some cases, a single symbol will refer to multiple points in the text. To encode multiple points of attachment, separate each `@target` value with a space:

```
<note type="lim" anchored="true">
<noteMarker ref="g:cross" target="#p525_n1 #p525_n3 #p525_n4"/>
</note>
```

If a note has multiple symbols, then encode each symbol and its target separately within a single `<note>`. For example:

```
<note type="lim" anchored="true">
    <noteMarker ref="g:cross" target="#p530_n1"/>
    <noteMarker ref="g:x" target="#p530_n2"/>
    <p>Vol: 1. p: <ref target="pg:195">195</ref>.</p>
</note>
```

Here is another example of a note with multiple targets and multiple symbols:

```
<note type="lim" anchored="true">
    <noteMarker ref="g:cross" target="#p525_n1 #p525_n3"/>
    <noteMarker ref="g:x" target="#p525_n2"/>
    <p>Vol: 1. p: <ref target="pg:187">187</ref>, <ref target="pg:194">194</ref>. Vol: 2. p: <ref target="pg:304">304</ref>, <ref target="pg:305">305</ref>.</p>
</note>
```	

## Unanchored Notes

Unanchored notes (i.e. floating or marginal notes) should be encoded using the `<note>` element with an `@type` value of "lim" and an `@anchored` value of "false". They should be encoded where (or close to where) they appear in the text. It is often difficult to pinpoint precisely where a note should go, but in most cases, you can use your best judgement for positioning the marginal note.

For position the note, use the `@place` attribute with one or more of the following values:

```{=tei}
<divGen xml:id="place_list"/>
```

## Nota Benes

Forbes' NBs are a special case. While they are nominally "notes," in practice, they function similarily to other structural features of a text (such as a postscript, closer, et cetera): they can appear both in the main stream of text as well as within notes (either comprising the entirety or only a portion of the note) and often have their own set of footnotes. 

Given the complexity and structural significance of Forbes' NBs, they have their own dedicated element in the LiM Schema: `<NB>`:

```{=tei}
<specList>
<specDesc key="NB"/>
</specList>
```

`<NB>`s that are part of the regular textual flow (i.e. as a separate paragraph or set of paragraphs at the end of an item) should simply wrap the paragraph:

```
         <closer rendition="rnd:right"> <salute><choice><orig>adew</orig><reg>adieu</reg></choice></salute>
            <signed><foreign xml:lang="la">Sic subr</foreign> Anne Leith</signed>
         </closer>
         <NB>
            <p>N:B: The Original of the
               <lb/>Above is to be found 
               <lb/>among my Papers.</p>
            <closer>
               <signed rendition="rnd:bordered-bottom-dashed">Robert Forbes A:M:</signed>
            </closer>
         </NB>
```

When an NB appears within a marginal note or a footnote, encode the `<NB>` _within_ the `<note>`:

```
<note type="lim" place="right">
    <NB>
        <p>P. 424</p>
        <signed>Robert Forbes A:M:</signed>
    </NB>
</note>
```











