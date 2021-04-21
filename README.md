# Lyon in Mourning Project Schema

This repository contains the schema, documentation, and oXygen editing framework for the Lyon in Mourning Project, a TEI-encoded edition of Robert Forbes' manuscript of Jacobite materials. The project is led by Dr. Leith Davis (SFU) with support provided by the Digital Humanities Innovation Lab (SFU Library).

The schema and documentation is encoded in P5 TEI XML and can be found in `schema/lim.odd`. The associated RelaxNG schema (with embedded schematron) is in `schema/lim.rng`.

The root `build.xml` file is an ant build script that:

* Creates the documentation from the TEI ODD file by running the ODD through a set of the TEI Stylesheets and some custom processing (`ant docs`)
* Packages the schema, templates, and author stylesheets into an oXygen XML framework (`ant framework`)

There are two GitHub actions associated with the repository, which handle automated deployment of the docs and the framework. Each job is run on any `push` event. 

* The `docs` job builds the documentation using `ant`, and pushes the built documents to the the `gh-pages` branch. 
* The `framework` job packages the framework using `ant` and updates the most recent release assets.

