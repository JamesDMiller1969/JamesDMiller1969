601,100
602,"Compress Files Example"
562,"NULL"
586,
585,
564,
565,"qQ>i;iH?]\<Nmqr`5a=aQAjTWpBsyH\fYoXMR\u;3u3KI^prOQPKBp3hdQUT??2pZA3?3\YGJj`kNOH_RTVYufG?v;qm3K?A`vY9Ri[tttf@9nDQoxi77c?JMfJEn7Q8d9J\rq2F]JRlVw_mETdTN[Xx\ZJ:f3hSq6ktx@sU`heNgACZa3S98E3b3B`iHk2Y8H^Mju\U"
559,1
928,0
593,
594,
595,
597,
598,
596,
800,
801,
566,0
567,","
588,"."
589,","
568,""""
570,
571,
569,0
592,0
599,1000
560,0
561,0
590,0
637,0
577,0
578,0
579,0
580,0
581,0
582,0
603,0
572,31

#****Begin: Generated Statements***
#****End: Generated Statements****

cGlobalCube = 'Global Variables';

# --- where is the compression application
# --- vCompressionApplication = 'c:\a_folder\7z.exe';
vCompressionApplication = CELLGETS(cGlobalCube, 'Compression Application', 'String');

# --- where are we compressing the files to
# --- vCompressionOutputlocation = 'c:\a_folder\';
vCompressionOutputlocation = CELLGETS(cGlobalCube, 'Compression Output location', 'String');

# --- what are we compressing
vWhatToCompress = 'c:\myTM1\PNG';

# --- where are we placing the compression processing log
# --- vCompressionLog = 'c:\a_folder\backuplog.txt';
vCompressionLog = CELLGETS(cGlobalCube, 'Compression Logging Output', 'String');

xnow = NOW();

sFileName = 'TM1_backup_' | TRIM(STR(xnow,9,0))  | '.zip';
sFileName = 'TM1_backup_' | TIMST(NOW(), '\Y\m\d_\h\i', 1) | '.zip';

vCommandLine = '"' | vCompressionApplication | '" a ' | '"' | vCompressionOutputlocation | sFilename | '" "' | vWhatToCompress  | '" > "' | vCompressionLog | '"';

EXECUTECOMMAND( vCommandLine,0);

# --- ASCIIOUTPUT('c:\a_folder\cmd.txt', vCommandLine);
573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,3

#****Begin: Generated Statements***
#****End: Generated Statements****
575,3

#****Begin: Generated Statements***
#****End: Generated Statements****
576,CubeAction=1511DataAction=1503CubeLogChanges=0
930,0
638,1
804,0
1217,0
900,
901,
902,
938,0
937,
936,
935,
934,
932,0
933,0
903,
906,
929,
907,
908,
904,0
905,0
909,0
911,
912,
913,
914,
915,
916,
917,0
918,1
919,0
920,50000
921,""
922,""
923,0
924,""
925,""
926,""
927,""
