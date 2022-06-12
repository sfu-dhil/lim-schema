# Document Structure

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



### Paragraphs



### Openers and Closers

#### Salutations

#### Signatures

#### Datelines

#### Postscripts



### 