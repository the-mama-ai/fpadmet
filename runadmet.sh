#!/bin/bash

#==============================================================================
# Software locations
PARENT_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

FPGEN="java -jar ${PARENT_PATH}/FINGERPRINTER/FingerprintGenerator.jar"
RSCRIPT="/usr/local/bin/Rscript"
PREDICTIONSCRIPTS="${PARENT_PATH}/PREDICTORS"
FPOUT="${PARENT_PATH}/RESULTS/temp/fps.txt"
PREDOUT="${PARENT_PATH}/RESULTS/temp"

#==============================================================================

NO_ARGS=0
E_OPTERROR=65


SCRIPTNAME=`basename "$0"`
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


function usage() {
   echo "Usage: $0 [-f <smi file>] [-p <property>] [-h <help>] [-a <calculate prediction uncertainty>]"; exit $E_OPTERROR;
   echo "=================================================================="
   echo "Provide the number corresponding to the property to be predicted"
   echo "=================================================================="
   echo " 1: Anticommensal Effect on Human Gut Microbiota"
   echo " 2: Blood-brain-barrier penetration"
   echo " 3: Oral Bioavailability"
   echo " 4: AMES Mutagenecity"
   echo " 5: Metabolic Intrinsic Clearance"
   echo " 6: Rat Acute LD50"
   echo " 7: Drug-Induced Liver Inhibition"
   echo " 8: HERG Cardiotoxicity"
   echo " 9: Haemolytic Toxicity"
   echo "10: Myelotoxicity"
   echo "11: Urinary Toxicity"
   echo "12: Human Intestinal Absorption"
   echo "13: Hepatic Steatosis"
   echo "14: Breast Cancer Resistance Protein Inhibition"
   echo "15: Drug-Induced Choleostasis"
   echo "16: Human multidrug and toxin extrusion Inhibition"
   echo "17: Toxic Myopathy"
   echo "18: Phospholipidosis"
   echo "19: Human Bile Salt Export Pump Inhibition"
   echo "20: Organic anion transporting polypeptide 1B1/1B3/2B1 binding"
   echo "23: Phototoxicity human/in vitro"
   echo "25: Respiratory Toxicity"
   echo "26: P-glycoprotein Inhibition"
   echo "27: P-glycoprotein Substrate"
   echo "28: Mitochondrial Toxicity"
   echo "29: Carcinogenecity"
   echo "30: DMSO Solubility"
   echo "31: Human Liver Microsomal Stability"
   echo "32: Human Plasma Protein Binding"
   echo "33: hERG Liability"
   echo "34: Organic Cation Transporter 2 Inhibition"
   echo "35: Drug-induced Ototoxicity"
   echo "36: Rhabdomyolysis"
   echo "37: T1/2 Human/Mouse/Rat"
   echo "40: Cytotoxicity HepG2/NIH cell line"
   echo "41: Cytotoxicity NIH-3T3 cell line"
   echo "42: Cytotoxicity HEK-293 cell line"
   echo "43: Cytotoxicity CRL-7250 cell line"
   echo "44: Cytotoxicity HaCat cell line"
   echo "45: CYP450 1A2 Inhibition"
   echo "46: CYP450 2C19 Inhibition"
   echo "47: CYP450 2D6 Inhibition"
   echo "48: CYP450 3A4 Inhibition"
   echo "49: CYP450 2C9 Inhibition"
   echo "50: pKa dissociation constant"
   echo "51: logD Distribution coefficient (pH 7.4)"
   echo "52: logS"
   echo "53: Drug affinity to human serum albumin"
   echo "54: MDCK permeability"
   echo "55: 50% hemolytic dose"
   echo "56: Skin Penetration"
   echo "57: CYP450 2C8 Inhibition"
   echo "58: Aqueous Solubility (in phosphate saline buffer)"
   echo "==================================================================="
}

adan=0

while getopts "f:p:ah" opt; do
    case $opt in
        h)
            usage
        ;;
        f)
#            echo "-f was triggered, Parameter: $OPTARG" >&2
            molfile=${OPTARG}
        ;;
        p)
#            echo "-p was triggered, Parameter: $OPTARG" >&2
            ptype=${OPTARG}
        ;;
        a)
#            echo "-a was triggered." >&2
            adan=1
        ;;
       \?)
#            echo "Invalid option: -$OPTARG" >&2
            usage
        ;;
        :)
#            echo "Option -$OPTARG requires an argument." >&2
            usage
        ;;
        *)
            usage
        ;;
    esac
done
shift $((OPTIND-1))


## initialize
retcode=0


## choose property model option and run

#for i in {3..4}
#do
#  case $i in
case $ptype in
      1)
#          echo "Anticommensal Effect on Human Gut Microbiota"

          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_anticommensal.R" $FPOUT $PREDOUT"/1.txt" $adan
          retcode=$?
          ;;
      2)
#          echo "Blood-brain-barrier penetration"
#          echo $FPOUT
#          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
#          $RSCRIPT $PREDICTIONSCRIPTS"/predict_bbbp.R" $FPOUT $PREDOUT"/2.txt" $adan
#          retcode=$?
#          ;;

          echo $PARENT_PATH
          echo $FPOUT

          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_bbbp.R" $FPOUT $PREDOUT"/2.txt" $adan
          retcode=$?
          ;;
      3)
#          echo "Oral Bioavailability"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_bioavailability.R" $FPOUT $PREDOUT"/3.txt" $adan
          retcode=$?
          ;;
      4)
#          echo "AMES Mutagenecity"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_ames.R" $FPOUT $PREDOUT"/4.txt" $adan
          retcode=$?
          ;;
      5)
#          echo "Metabolic Intrinsic Clearance"
          $FPGEN -output $FPOUT -fptype FCFP4 -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_metabolicstability.R" $FPOUT $PREDOUT"/5.txt" $adan
          retcode=$?
          ;;
      6)  echo "Rat Acute LD50"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_rattoxicity.R" $FPOUT $PREDOUT"/6.txt" $adan
          retcode=$?
          ;;
      7)  echo "Drug-Induced Liver Inhibition"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_DILI.R" $FPOUT $PREDOUT"/7.txt" $adan
          retcode=$?
          ;;
      8)  echo "HERG Cardiotoxicity"
          $FPGEN -output $FPOUT -fptype FCFP6 -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_hergcardiotox.R" $FPOUT $PREDOUT"/8.txt" $adan
          retcode=$?
          ;;
      9)  echo "Haemolytic Toxicity"
          $FPGEN -output $FPOUT -fptype FCFP6 -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_hemotox.R" $FPOUT $PREDOUT"/9.txt" $adan
          retcode=$?
          ;;
      10) echo "Myelotoxicity"
          $FPGEN -output $FPOUT -fptype FCFP4 -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_myelotox.R" $FPOUT $PREDOUT"/10.txt" $adan
          retcode=$?
          ;;
      11) echo "Urinary Toxicity"
          $FPGEN -output $FPOUT -fptype FCFP4 -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_urinarytox.R" $FPOUT $PREDOUT"/11.txt" $adan
          retcode=$?
          ;;
      12) echo "Human Intestinal Absorption"
          $FPGEN -output $FPOUT -fptype MACCS -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_HIA.R" $FPOUT $PREDOUT"/12.txt" $adan
          retcode=$?
          ;;
      13) echo "Hepatic Steatosis"
          $FPGEN -output $FPOUT -fptype MACCS -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_steatosis.R" $FPOUT $PREDOUT"/13.txt" $adan
          retcode=$?
          ;;
      14) echo "Breast Cancer Resistance Protein Inhibition"
          $FPGEN -output $FPOUT -fptype FCFP4 -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_bcrpinhibition.R" $FPOUT $PREDOUT"/14.txt" $adan
          retcode=$?
          ;;
      15) echo "Drug-Induced Choleostasis"
          $FPGEN -output $FPOUT -fptype MOLPRINT2D -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_choleostasis.R" $FPOUT $PREDOUT"/15.txt" $adan
          retcode=$?
          ;;
      16) echo "Human multidrug and toxin extrusion Inhibition" # MATE1
          $FPGEN -output $FPOUT -fptype DFS -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_MATE1.R" $FPOUT $PREDOUT"/16.txt" $adan
          retcode=$?
          ;;
      17) echo "Toxic Myopathy"
          $FPGEN -output $FPOUT -fptype DFS -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_myopathy.R" $FPOUT $PREDOUT"/17.txt" $adan
          retcode=$?
          ;;
      18) echo "Phospholipidosis"
          $FPGEN -output $FPOUT -fptype FCFP2 -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_phospholipidosis.R" $FPOUT $PREDOUT"/18.txt" $adan
          retcode=$?
          ;;
      19) echo "Human Bile Salt Export Pump Inhibition"
          $FPGEN -output $FPOUT -fptype ECFP4 -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_BSEP.R" $FPOUT $PREDOUT"/19.txt" $adan
          retcode=$?
          ;;
      20) echo "Organic anion transporting polypeptide 1B1 binding"
          $FPGEN -output $FPOUT -fptype ECFP6 -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_OATP1B1.R" $FPOUT $PREDOUT"/20.txt" $adan
          retcode=$?
          ;;
      21) echo "Organic anion transporting polypeptide 1B3 binding"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_OATP1B3.R" $FPOUT $PREDOUT"/21.txt" $adan
          retcode=$?
          ;;
      22) echo "Organic anion transporting polypeptide 2B1 binding"
          $FPGEN -output $FPOUT -fptype ECFP6 -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_OATP2B1.R" $FPOUT $PREDOUT"/22.txt" $adan
          retcode=$?
          ;;
      23) echo "Phototoxicity human"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_phototoxhuman.R" $FPOUT $PREDOUT"/23.txt" $adan
          retcode=$?
          ;;
      24) echo "Phototoxicity invitro"
          $FPGEN -output $FPOUT -fptype KR -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_phototoxinvitro.R" $FPOUT $PREDOUT"/24.txt" $adan
          retcode=$?
          ;;
      25) echo "Respiratory Toxicity"
          $FPGEN -output $FPOUT -fptype MACCS -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_respiratorytox.R" $FPOUT $PREDOUT"/25.txt" $adan
          retcode=$?
          ;;
      26) echo "P-glycoprotein Inhibition"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_pgpinhibition.R" $FPOUT $PREDOUT"/26.txt" $adan
          retcode=$?
          ;;
      27) echo "P-glycoprotein Substrate"
          $FPGEN -output $FPOUT -fptype ASP -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_pgpsubstrate.R" $FPOUT $PREDOUT"/27.txt" $adan
          retcode=$?
          ;;
      28) echo "Mitochondrial Toxicity"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_mitichondrialtox.R" $FPOUT $PREDOUT"/28.txt" $adan
          retcode=$?
          ;;
      29) echo "Carcinogenecity"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_carcinogenecity.R" $FPOUT $PREDOUT"/29.txt" $adan
          retcode=$?
          ;;
      30) echo "DMSO Solubility"
          $FPGEN -output $FPOUT -fptype ECFP2 -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_DMSO.R" $FPOUT $PREDOUT"/30.txt" $adan
          retcode=$?
          ;;
      31) echo "Human Liver Microsomal Stability"
          $FPGEN -output $FPOUT -fptype AT2D -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_HLMstability.R" $FPOUT $PREDOUT"/31.txt" $adan
          retcode=$?
          ;;
      32) echo "Human Plasma Protein Binding"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_PPB.R" $FPOUT $PREDOUT"/32.txt" $adan
          retcode=$?
          ;;
      33) echo "hERG Liability"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_hergliability.R" $FPOUT $PREDOUT"/33.txt" $adan
          retcode=$?
          ;;
      34) echo "Organic Cation Transporter 2 Inhibition"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_OCT2inhibition.R" $FPOUT $PREDOUT"/34.txt" $adan
          retcode=$?
          ;;
      35) echo "Drug-induced Ototoxicity"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_ototoxicity.R" $FPOUT $PREDOUT"/35.txt" $adan
          retcode=$?
          ;;
      36) echo "Rhabdomyolysis"
          $FPGEN -output $FPOUT -fptype MACCS -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_rhabdomyolysis.R" $FPOUT $PREDOUT"/36.txt" $adan
          retcode=$?
          ;;
      37) echo "T1/2 Human"
          $FPGEN -output $FPOUT -fptype ASP -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_thalfhuman.R" $FPOUT $PREDOUT"/37.txt" $adan
          retcode=$?
          ;;
      38) echo "T1/2 Mouse"
          $FPGEN -output $FPOUT -fptype ECFP2 -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_thalfmouse.R" $FPOUT $PREDOUT"/38.txt" $adan
          retcode=$?
          ;;
      39) echo "T1/2 Rat"
          $FPGEN -output $FPOUT -fptype KR -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_thalfrat.R" $FPOUT $PREDOUT"/39.txt" $adan
          retcode=$?
          ;;
      40) echo "Cytotoxicity HepG2 cell lines"
          $FPGEN -output $FPOUT -fptype AT2D -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_cytotoxicityhepg2.R" $FPOUT $PREDOUT"/40.txt" $adan
          retcode=$?
          ;;
      41) echo "Cytotoxicity NIH-3T3 cell lines"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_cytotoxicitynih.R" $FPOUT $PREDOUT"/41.txt" $adan
          retcode=$?
          ;;
      42) echo "Cytotoxicity HEK 293 cell lines"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_cytotoxicityhek.R" $FPOUT $PREDOUT"/42.txt" $adan
          retcode=$?
          ;;
      43) echo "Cytotoxicity CRL-7250 cell lines"
          $FPGEN -output $FPOUT -fptype AT2D -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_cytotoxicitycrl.R" $FPOUT $PREDOUT"/43.txt" $adan
          retcode=$?
          ;;
      44) echo "Cytotoxicity HaCat cell lines"
          $FPGEN -output $FPOUT -fptype AT2D -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_cytotoxicityhacat.R" $FPOUT $PREDOUT"/44.txt" $adan
          retcode=$?
          ;;
      45) echo "CYP450 1A2 Inhibition"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_cyp1a2.R" $FPOUT $PREDOUT"/45.txt" $adan
          retcode=$?
          ;;
      46) echo "CYP450 2C19 Inhibition"
          $FPGEN -output $FPOUT -fptype ECFP4 -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_cyp2c19.R" $FPOUT $PREDOUT"/46.txt" $adan
          retcode=$?
          ;;
      47) echo "CYP450 2C9 Inhibition"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_cyp2c9.R" $FPOUT $PREDOUT"/47.txt" $adan
          retcode=$?
          ;;
      48) echo "CYP450 2D6 Inhibition"
          $FPGEN -output $FPOUT -fptype FCFP4 -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_cyp2d6.R" $FPOUT $PREDOUT"/48.txt" $adan
          retcode=$?
          ;;
      49) echo "CYP450 3A4 Inhibition"
          $FPGEN -output $FPOUT -fptype FCFP6 -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_cyp3a4.R" $FPOUT $PREDOUT"/49.txt" $adan
          retcode=$?
          ;;
      50) echo "pKa dissociation constant"
          $FPGEN -output $FPOUT -fptype ECFP2 -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_pka.R" $FPOUT $PREDOUT"/50.txt" $adan
          retcode=$?
          ;;
      51) echo "logD Distribution coefficient (pH 7.4)"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_logD.R" $FPOUT $PREDOUT"/51.txt" $adan
          retcode=$?
          ;;
      52) echo "logS"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_logS.R" $FPOUT $PREDOUT"/52.txt" $adan
          retcode=$?
          ;;
      53) echo "Drug affinity to human serum albumin"
          $FPGEN -output $FPOUT -fptype AP2D -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_HSA.R" $FPOUT $PREDOUT"/53.txt" $adan
          retcode=$?
          ;;
      54) echo "MDCK permeability"
          $FPGEN -output $FPOUT -fptype ECFP4 -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_MDCKPerm.R" $FPOUT $PREDOUT"/54.txt" $adan
          retcode=$?
          ;;
      55) echo "50% hemolytic dose"
          $FPGEN -output $FPOUT -fptype ASP -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_HD50.R" $FPOUT $PREDOUT"/55.txt" $adan
          retcode=$?
          ;;
      56) echo "Skin penetration"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_skinpen.R" $FPOUT $PREDOUT"/56.txt" $adan
          retcode=$?
          ;;
      57) echo "CYP450 2C8 Inhibition"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_cyp2c8.R" $FPOUT $PREDOUT"/57.txt" $adan
          retcode=$?
          ;;
      58) echo "Aqueous Solubility (in phosphate saline buffer)"
          $FPGEN -output $FPOUT -fptype PUBCHEM -mol $molfile
          $RSCRIPT $PREDICTIONSCRIPTS"/predict_AQSOL.R" $FPOUT $PREDOUT"/58.txt" $adan
          retcode=$?
          ;;
      *)  echo "ERROR: Ill-defined task number."
      usage;
          exit $E_OPTERROR
          ;;
esac



exit $retcode

