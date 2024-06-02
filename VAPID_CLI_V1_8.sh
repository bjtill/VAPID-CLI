#!/bin/bash
#BT & AG, March 14, 2023
#Version 1.6 updated for batch processing, with VCF path option removed. GUI version handles paths, and CLI is better suited to batch. 
#Version 1.7 adds date to logfile 
#Version 1.8 updates progress text
##################################################################################################################################

# Help
[ "$1" = "-h" -o "$1" = "--help" ] && echo "

VAPID Version 1.8
 
ABOUT: 

VCFs annotated with the tool SnpEff (https://pcingola.github.io/SnpEff/) contain information about the potential effect of each sequence variant on gene function. A perl script (vcfEffOnePerLine.pl) is provided with SnpEff to extract the EFF information from an annotated VCF.  The VAPID tool was created to facilitate the use of the perl script so that a common set of annotation information can be easily extracted and formatted from single or multi-sample VCFs.  Creating this code was part of an undergraduate research training program with Anna Grulikowski, who was a student of UC Davis.  We created a command line interface (CLI) version, and a graphical user interface (GUI) version of VAPID.  The command line version provides a feature that allows the batch processing of multiple VCFs.  The GUI version does not support batch processing, but does not require the use of the command line interface, except to launch the program. 


REQUIREMENTS:

perl, java, bash, awk, an internet connection

TO RUN:

1. Download the latest version of VAPID.sh.

2. Place this program into the directory that contains all the VCFs you wish to process. Open a terminal window in the directory containing the program and type chmod +x VAPID_CLI_V1_3.sh. Check to make sure that the name is an exact match to the .sh file you are using as the version may change. 

4. Download the SnpEff & SnpSift bundle (https://pcingola.github.io/SnpEff/download/)

5. Get the path of the SnpSift.jar file. This is needed to run the program.  If you don’t know how to get the path, simply drag the .jar file into a terminal window and the path will appear.  The single quotations, if present, need to be removed.  For example, the path on my computer is /home/brad/snpEff/SnpSift.jar

6. Run the program.  Open a terminal window in the directory that contains the VAPID program and all the VCFs you wish to process.  In Linux, right click and select “Open in Terminal” to open a terminal window in the correct location.  Next, launch the program with the path to SnpSift.jar as parameter -s

./VAPID_CLI_V1_6.sh -s /home/brad/snpEff/SnpSift.jar

WARNING: Paths to files should not contain spaces or extra symbols other than _ .  For example, if your SnpSift.jar file is on USB drive titled My Book, the program will not work.  It will work if your file is on a drive named My_Book.  
	
LICENSE:  
MIT License 
Copyright (c) 2024 Bradley John Till & Anna Grulikowski 
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the *Software*), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
Version Information:  Version 1.8, May 23, 2024
" && exit

############################################################################################################################

helpFunction()
{
   echo ""
   echo "Usage: $0 -s SnpSiftpath"
   echo ""
   echo -e "\t-s Path to SnpSift.jar, for example /home/brad/snpEff/SnpSift.jar \n"
   echo ""
   echo "For more detailed help and to view the license, type $0 -h"
   echo ""
   exit 1 # Exit script after printing help
}

while getopts "s:" opt
do
   case "$opt" in
      s ) parameterA="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$parameterA" ] 
then

   echo ""
   echo "You forgot to add the path to the SnpSift.jar file.  Please try again.";
   helpFunction
fi

############################################################################################################################
log=VAPIDt.log
now=$(date)  
echo "VAPID Version 1.8
-h for help
Script Started $now"  > $log

OR='\033[0;33m'
NC='\033[0m'
printf "${OR}VAPID 1.8
-h for help
Script Started $now.${NC}\n" 
############################################################################################################################
printf "${OR}Downloading perl script and collecting sample names from VCF${NC}\n" 
curl https://raw.githubusercontent.com/pcingola/SnpEff/master/scripts/vcfEffOnePerLine.pl > vcfEffOnePerLine.pl
for i in *.vcf; do 
bcftools query -l $i | datamash transpose > ${i%.*}.samples
printf "${OR}Extracting information from VCF (this may take some time)${NC}\n" 
cat $i | ./vcfEffOnePerLine.pl | java -jar $parameterA extractFields - "ANN[*].GENE" "EFF[*].GENE" "ANN[*].FEATUREID" CHROM POS  "EFF[*].EFFECT" "ANN[*].IMPACT" "EFF[*].AA" "ANN[*].HGVS_C" "GEN[*].GT" > ${i%.*}.tmp
printf "${OR}Formatting data table${NC}\n"
tail -n +2 ${i%.*}.tmp > ${i%.*}.tmp1
awk '{print "AnnotatedGeneName", "EffGeneName", "FeatureID", "Chrom", "POS", "Effect", "Impact", "AAchange", "NucChange", $0}' ${i%.*}.samples > ${i%.*}.header1
tr ' ' '\t' < ${i%.*}.header1 > ${i%.*}.header2
printf "${OR}Final steps${NC}\n" 
cat ${i%.*}.header2 ${i%.*}.tmp1 > ${i%.*}_VAPID.text; done 
rm *.samples *.tmp *.tmp1 *.header1 *.header2

now=$(date)  
printf "${OR}Script Finished $now. The logfile is named VAPID.log.${NC}\n" 
echo "Script Finished $now." >> log
#Collect info on user parameters
a=$(echo "$parameterA")
b=$(date +"%m_%d_%y_at_%H_%M")
awk -v var=$a '{print "Path to SnpSift.jar:", var}' log > log2 
cat VAPIDt.log log log2 > VAPID_${b}.log
rm VAPIDt.log log log2

##############END OF PROGRAM #######################################################################################################
