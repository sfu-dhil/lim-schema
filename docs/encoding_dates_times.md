# Encoding Dates and Times

This document describes the protocol for encoding dates and times within transcriptions.

Note that you should only encode *real* dates and *real* times; in other words, we are interested in identifying specific points in time and not broad or general references to time.

## Dates

Use the `<date>` element to encode dates; the date (in YYYY-MM-DD format) should be encoded using the `@when` attribute:

```
I was in Switzerland in the year
<lb/><date when="1734">1734</date>.
```

Tag only the minimum information necessary for the date. For instance, in the following `<dateline>`, you would only encode the "Augt 18th, 1746" part of the date, even though there is additional information:  

```
<dateline>
Upon Tower-hill, Monday, <date when="1746-08-18">Augt
<lb/>18th, 1746</date>. in the 58th year
<lb/>of his Age.</dateline>
```

For a date range, use the `@from` and `@to` attributes:

```
I travelled to Geneva from <date from="1746-08-18" to="1746-09-03">August 18, 1746 to September 3</date>
```

For uncertain date ranges, use the `@notBefore` and `@notAfter` attributes (NB: this isn't very common within text transcriptions, but is frequently necessary for person record when describing dates of birth or residence).

## Times

Times follow similar rules to dates: encode the time using the `<time>` element. 

Each time must contain a `@when` attribute that specifies the time in the 24 hour clock in the format HH:MM:SS (i.e. 4:15pm would be encoded as 16:15:00). For example:

```
About <time when="11:00:00">eleven o’Clock</time> He ordered them
			<lb/>to refresh themselves by Sleep
```			
Each time must include hours, minutes, and seconds (even though it will be rare for seconds to be specified in the text).

When both a time and date are combined, use the `<date>` element to encode the entire phrase and tag the `<time`> within the date:

```
About <date when="1746-04-16"><time when="02:00:00">2 o’Clock of the <w>Morn<pc force="weak">-</pc>
			<lb/>ing</w></time> of the 16<hi rendition="rnd:underlined">th</hi></date>
```




