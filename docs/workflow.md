
# Workflow

## Updating your Repository

Update your local copy of the repository by merging any changes from the upstream repository. To do so:

* Open GitHub Desktop and click the branch tab (the second tab on the top; it will say something like "main"): 

* In the branch menu, click Choose branch to merge into main: 

* Click on upstream/main: 

* Depending on whether your repository is up to date: 
	* If there are no changes to merge (This branch is up to date ...), then you're done!

	* If there are changes to merge (This will merge x commits...), then click Merge upstream/main


## Editing in oXygen

All work on the TEI documents should be done in oXygen. It is an incredibly powerful and useful tool for editing XML and there are a number of custom features and tools that will editing easier and more efficient.

When you open oXygen, make sure you see the `lim-data.xpr` project in the oXygen project pane (usually on the left-hand side):  oXygen remembers the last project you opened, so it will usually use the `lim-data` project file automatically. If, for whatever reason, you are not in the `lim-data` project, make sure to open the project file by going to `Project/Open Project` in the toolbar. You can use the Project pane to navigate through the project files; all of the TEI files are in the `data/` folder.

As you edit your TEI file in oXygen, it is imperative that you frequently and consistently validate your file. Invalidities in an oXygen are signalled much like spell-check: the invalid element is underlined in red and its location in the document is marked in the scrollbar.

oXygen validates for you automatically as you type, but it might lag (especially for large or complex documents), so it is best practice to trigger validation manually as well, especially before committing your changes.

To validate your document, you can either use the keyboard shortcut CMD+Shift+V (CMD = ⌘ on Mac) or click the red checkmark in the toolbar:  Once the document finishes validating, there will be a message at the bottom of the screen stating whether validation was successful. If there are errors in your document and validation fails, you will see the red underlines and a info box at the bottom of the screen that outlines the precise errors.  Try your best to determine what the error is: the validation message usually provides a good indication of what the pfrom the validation message (some are more helpful than others); the problem is quite often something simple like a typo, an errant space at the beginning or end of an element, or a missing quotation mark.

If you can't figure out the error, then it is OK to commit the file, but do let the team and the developers know right away so that the error can be resolved as soon as possible.

## Committing Changes

After you've made a set of changes (i.e. before you take a break or before the end of your work day) and confirmed that they were valid, you need to commit those changes to the repository. To do that, navigate to GitHub Desktop, which should show you a list of changes that you've made: 

It is a good idea to review those changes to make sure everything looks right (i.e. all of the files that you actually changed are listed; there are no additional changes). (You may see that the `lim-data.xpr` oXygen project file has changed even though you didn't do anything to it—that's expected).

Assuming that everything looks correct, you can then commit those files by filling out the commit message boxes in the bottom left-hand corner:  These commit messages are helpful for record keeping and for tracking changes to the files; note that these commit messages are both permanent and public. In the `Summary` field, add a brief description of what you've done (i.e. "Added index items for vol7"). If there is additional information you'd like to add, put a longer explanation in the `Description` box.
