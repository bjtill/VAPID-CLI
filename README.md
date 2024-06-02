# VAPID-CLI
Variants Annotated and Parsed from Imported Data, Command Line Version.  A tool to help convert variant call format (VCF) files annotated with SnpEff into a human readable table.  
___________________________________________________________________________________

Use at your own risk.
I cannot provide support. All information obtained/inferred with this script is without any implied warranty of fitness for any purpose or use whatsoever.

ABOUT: 

VCFs annotated with the tool SnpEff (https://pcingola.github.io/SnpEff/) contain information about the potential effect of each sequence variant on gene function. A perl script (vcfEffOnePerLine.pl) is provided with SnpEff to extract the EFF information from an annotated VCF.  The VAPID tool was created to facilitate the use of the perl script so that a common set of annotation information can be easily extracted and formatted from single or multi-sample VCFs.  Creating this code was part of an undergraduate research training program with Anna Grulikowski, who was a student of UC Davis.  We created a command line interface (CLI) version, and a graphical user interface (GUI) version of VAPID.  The command line version provides a feature that allows the batch processing of multiple VCFs.  The GUI version does not support batch processing, but does not require the use of the command line interface, except to launch the program. 

HOW IT WORKS: 

VAPID uses bcftools query to collect sample name information from the input VFC.  The script vcfEffOnePerLine.pl is used to collect the EFF information from the VCF, and SnpSift.jar is used to extract the ANN.GENE, EFF.GENE, ANN.FEATURED, CHROM, POS, EFF.EFFECT, ANN.IMPACT, EFF.AA, ANN.HGVS_C and GEN.GT fields.  Awk is used to create a header for the resulting table.  

REQUIREMENTS:

perl, java, bash, awk

OPERATING SYSTEMS: 

VAPID was built to work on a Linux system with Bash (Bourne-Again SHell). The CLI should work on MacOS, and in theory will work on a Windows machine running a Bash emulator (neither have been).   The GUI version was built using YAD.  Our attempts at installing YAD on MacOS failed.  If you are interested in making a GUI version for Mac, try Zenity, which can be installed using homebrew.  See the Mutation_Finder_Annotator tool for an example of using Zenity (https://github.com/bjtill/Mutation-Finder-Annotator-GUI/blob/main/Mutation_Finder_Annotator_GUI_V1_5.sh).  

TO RUN:

1. Download the latest version of VAPID_CLI.sh.
2. Place this program into the directory that contains all the VCFs you wish to process. Open a terminal window in the directory containing the program and type chmod +x VAPID_CLI_V1_3.sh. Check to make sure that the name is an exact match to the .sh file you are using as the version may change. 
4. Download the SnpEff & SnpSift bundle (https://pcingola.github.io/SnpEff/download/)
5. Get the path of the SnpSift.jar file. This is needed to run the program.  If you don’t know how to get the path, simply drag the .jar file into a terminal window and the path will appear.  The single quotations, if present, need to be removed.  For example, the path on my computer is /home/brad/snpEff/SnpSift.jar
5. Run the program.  Open a terminal window in the directory that contains the VAPID program and all the VCFs you wish to process.  In Linux, right click and select “Open in Terminal” to open a terminal window in the correct location.  Next, launch the program with the path to SnpSift.jar as parameter -s
./VAPID_CLI_V1_8.sh -s /home/brad/snpEff/SnpSift.jar

OUTPUTS: 

1. A table containing the results with the extension .txt.
2. A log file. 
