# Transcription Encoding Workflow

We use a multi-stage workflow for the transcriptions in order to allow for ease of collaboration during the transcription stage. All of the transcriptions are in the Google Drive folder; depending on the individual transcriber's preference, this transcription may have been automatically generated from Transkribus or has been transcribed by hand.

Once the transcription has been finished and proofed according to the guidelines in the Google Drive, the next step is to encode the transcription in TEI.
We have an automated process for creating a semi-valid TEI document from the Google Doc transcription. Since Google Doc is a presentation format, the transformation from the Google Doc to TEI will be necessarily imperfect and will require significant manual editing in order to ensure that the structure, semantics, and presentation of the text are encoded properly.

## Step 0: Update your repository

Before encoding your transcription, make sure you have your GitHub and oXygen environments properly set up (see [Getting Started](getting_started.md)) and that you have update your local version of the repository (see [Workflow](workflow.md)).

## Step 1: Check Google Drive Transcription

The automated conversion process makes a number of assumptions about the format of the Transcription Roster and the Google Doc; any divergence from these assumptions will quite likely cause the transformation to fail, so it is best to ensure the following before proceeding to run the conversion:

1. The transcription roster MUST contain the IDs of the assigned transcriber, the actual transcriber, and the proofer where the ID is usually the person's initials and a 1 (i.e. JT1). If there are multiple people for a given role, separate with a slash (i.e. JT1/LD1). 
    * Ensure that these cells DO NOT contain any spaces
1. The document ID in the first cell MUST match the name of the document in Google Drive, which MUST match the name of the document's ID (i.e. v01.0001.01).
1. Transcriptions MUST NOT contain any Track Changes (insert, remove, format, etc). Ensure that all track changes are resolved before converting (NB: comments and notes are OK as these are converted to XML comments (`<!-- comment -->`)

Once you have confirmed the above, add your ID to the ENCODER column. This is important as we want to avoid multiple people encoding an item. 

## Step 2: Convert the Transcription

1. Open the Google Doc transcription and copy the document's URL 
1. Open oXygen (and confirm you are in the lim-data project--it should say `lim-data.xpr` in the corner
1. Scroll to the bottom of the project pane, find the file named `convertTranscription.html`, and double-click it to open it 

![Conversion page](images/convert_convertPage.png)


1. Then press the red "Play" button (a white circle with a red triangle)

 ![Conversion page](images/convert_convertPageButton.png)
  
    
1. The first is your encoder ID. Enter your id (i.e. LD1) and press OK

 ![encoder ID popup page](images/convert_convertPageButton.png)

1. The second is the Google Doc URL. Paste in the Google Doc's URL and press OK

A pane should appear at the bottom of your oXygen application with a bunch of messages that scroll past as the conversion process proceeds. This will take about a minute or so.

Once the conversion is finished (and if it did not encounter any errors), then the document should automatically open in a new tab in oXygen.

If the document does not open automatically,  receive a BUILD FAILED message and






