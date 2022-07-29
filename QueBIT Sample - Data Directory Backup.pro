601,100
602,"QueBIT Sample - Data Directory Backup"
562,"NULL"
586,
585,
564,
565,"aajJt\7kz^5`2:q0izhISah56wJhfxySBG?X@A7Nvy[`rXXBa7@l;ZxobRO^QAokWPkWhWb`y\w4;f@INUnBBpO`DcTYZ4^7s@PtgM94Ark@k_zh=Kws;iI[]4cQZ?Xsxu\W@O=yK:AZagxednh6AqW[R^z_uCwPFM13CvOTXj`ykmz7tY<soQhJWV0kPsgpX>Vj`@Sm"
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
572,505

#****Begin: Generated Statements***
#****End: Generated Statements****

#==========================================================================================
# PROCESS
# QueBIT Sample - Data Directory Backup
#==========================================================================================
# 
# Jul 06, 2021
#
# PURPOSE:
sDescription = 'Creates a Data directory backup, Cleans up log files and Creates Misc folder backups. Called by System - Backup Data Directory Chore' ; 
#
#      This process can be run ad hoc or scheduled via a chore to create a backup of the TM1 Data Directory 
#         and up to three other Miscellaneous Directories associated with the TM1 Model
#      Additionally this process can compress the backup files in the .zip format if a 7-zip command line executable is available
#         If file compression is available the process will archive the last day of each month in a seperate 'Archive' folder created under the backup directory
#      This process will also cleanup log files and backups older than a defined number of days if configured within the TM1 Backup Variables cube
#         Finally this process will create a log of all actions within the backup directory
#   DEPENDEICIES:
#      TM1 Backup Variables cube with populated values
#         Defined Directory for Backups
# DATA SOURCE:
sSource = '' ;
#
# TARGET:
sTarget = '' ;
#
# PARAMETERS:
#
sParameters = '' ;
sParameterList = '' ;
#
# MODIFICATION HISTORY:
#     When updates are made, comment out previous sUpdate and create new to preserve history of changes
sUpdate = 'Jul 06, 2021 - RMH - Created Process' ; 
#
#==========================================================================================

#===============================  Process Statistics ======================================
cubProcessStatistics = 'Process Statistics' ;
proProcess = GETPROCESSNAME ;
sysLogFile = GETPROCESSERRORFILEDIRECTORY | GETPROCESSERRORFILENAME ;
sNow = TIMST( NOW , '\M \D, \Y at \H \p \i min \s sec' ) ;
sDate = TIMST( NOW , '\Y\m\d' ) ;
sLine = CELLGETS ( cubProcessStatistics , 'All Line Items' , proProcess , sDate , 'Current Line Item' ) ;
CELLPUTS( sNow , cubProcessStatistics , sLine , proProcess , sDate , 'Start Time' ) ;
CELLPUTS( sNow , cubProcessStatistics , sLine , proProcess , 'Latest' , 'Start Time' ) ;
CELLPUTS( 'Did not end' , cubProcessStatistics , sLine , proProcess , sDate , 'End Time' ) ;
CELLPUTS( 'Did not end' , cubProcessStatistics , sLine , proProcess , 'Latest' , 'End Time' ) ;
nNowStart = NOW ;
IF( DIMIX( '}Clients' , TM1USER() ) <> 0 ) ;
  usrName = ATTRS('}Clients', TM1USER() , '}TM1_DefaultDisplayValue' ) ;
ELSE ;
  usrName = TM1USER() ;
ENDIF ;
CELLPUTS( usrName , cubProcessStatistics , sLine , proProcess , sDate , 'Last Executed By' ) ;
CELLPUTS( usrName , cubProcessStatistics , sLine , proProcess , 'Latest' , 'Last Executed By' ) ;
nRecordCount = 0 ;
CELLPUTN( nRecordCount , cubProcessStatistics , sLine , proProcess , sDate , 'Record Count' ) ;
CELLPUTN( nRecordCount , cubProcessStatistics , sLine , proProcess , 'Latest' , 'Record Count' ) ;
nRecordProcess = 0 ;
CELLPUTN( nRecordProcess , cubProcessStatistics , sLine , proProcess , sDate , 'Processed Records' ) ;
CELLPUTN( nRecordProcess , cubProcessStatistics , sLine , proProcess , 'Latest' , 'Processed Records' ) ;
nRecordSkip = 0 ;
CELLPUTN( nRecordSkip , cubProcessStatistics , sLine , proProcess , sDate , 'Skipped Records' ) ;
CELLPUTN( nRecordSkip , cubProcessStatistics , sLine , proProcess , 'Latest' , 'Skipped Records' ) ;
nSourceTotal = 0 ;
nTargetTotal = 0 ;
CELLPUTS( '' , cubProcessStatistics , sLine , proProcess , sDate , 'Error Reason' ) ;
CELLPUTS( '' , cubProcessStatistics , sLine , proProcess , 'Latest' , 'Error Reason' ) ;
sParameters = sParameters ;
sParameterList = sParameterList ;
CELLPUTS( sParameters , cubProcessStatistics , sLine ,  proProcess , sDate , 'Parameters' ) ;
CELLPUTS( sParameters , cubProcessStatistics , sLine ,  proProcess , 'Latest' , 'Parameters' ) ;
CELLPUTS( sParameterList , cubProcessStatistics , 'All Line Items' , proProcess , 'All Daily Time' , 'List of Parameters' ) ;
CELLPUTS( sDescription , cubProcessStatistics , 'All Line Items' , proProcess , 'All Daily Time' , 'Description' ) ;
CELLPUTS( sSource , cubProcessStatistics , 'All Line Items' , proProcess , 'All Daily Time' , 'Source' ) ;
CELLPUTS( sTarget , cubProcessStatistics , 'All Line Items' , proProcess , 'All Daily Time' , 'Target' ) ;
CELLPUTS( sUpdate , cubProcessStatistics , 'All Line Items' , proProcess , 'All Daily Time' , 'Last Updated' ) ;
#==========================================================================================

##############
# SAVE DATA ALL
##############

SAVEDATAALL;

##########################################
# Set Variables for Process from TM1 Backup Variables cube
##########################################

cubGlobal = 'Global Assumptions' ; 
vServerName = CELLGETS ( cubGlobal , 'PA Instance Name', 'String' ) ;
vBackupDirectory = CELLGETS ( cubGlobal , 'Backup Directory', 'String' ) ;
vDataDirectory = CELLGETS ( cubGlobal , 'Data Directory', 'String' ) ;
vLogDirectory = CELLGETS ( cubGlobal , 'Log Directory', 'String' ) ; 

#vMiscDirectory1 = CELLGETS ( cubGlobal , 'Miscellaneous Directory 1', 'String' ) ;
#vMiscDirectory2 = CELLGETS ( cubGlobal , 'Miscellaneous Directory 2', 'String' ) ;
#vMiscDirectory3 = CELLGETS ( cubGlobal , 'Miscellaneous Directory 3', 'String' ) ;
vMiscDirectory1 = '' ;
vMiscDirectory2 = '' ;
vMiscDirectory3 = '' ;

cLogLife = CELLGETS ( cubGlobal , 'Log Retention Days', 'String' ) ;  
cBackupLife = CELLGETS ( cubGlobal , 'Backup Retention Days', 'String' ) ;  

######################
# Directory Path Error Checking
######################

IF ( vServerName @= '' % vBackupDirectory@= '' % vDataDirectory @= '' ) ;
  PROCESSBREAK ;
ENDIF;

IF ( SUBST ( vBackupDirectory, LONG ( vBackupDirectory), 1 ) @<> '\' ) ;
  vBackupDirectory = vBackupDirectory | '\' ;
ENDIF;

IF ( SUBST ( vDataDirectory, LONG ( vDataDirectory ) , 1 ) @= '\' ) ;
  vDataDirectory = DELET ( vDataDirectory, LONG ( vDataDirectory ), 1 ) ;
ENDIF;

IF ( vLogDirectory @<> '' ) ;
  IF ( SUBST ( vLogDirectory, LONG ( vLogDirectory ) , 1 ) @= '\' ) ;
    vLogDirectory = DELET ( vLogDirectory, LONG ( vLogDirectory ), 1 ) ;
  ENDIF;
ENDIF;

IF ( vMiscDirectory1 @<> '' ) ;
  IF ( SUBST ( vMiscDirectory1, LONG ( vMiscDirectory1 ) , 1 ) @= '\' ) ;
    vMiscDirectory1 = DELET ( vMiscDirectory1, LONG ( vMiscDirectory1 ), 1 ) ;
  ENDIF;
ENDIF;

IF ( vMiscDirectory2 @<> '' ) ;
  IF ( SUBST ( vMiscDirectory2, LONG ( vMiscDirectory2 ) , 1 ) @= '\' ) ;
    vMiscDirectory2 = DELET ( vMiscDirectory2, LONG ( vMiscDirectory2 ), 1 ) ;
  ENDIF;
ENDIF;

IF ( vMiscDirectory3 @<> '' ) ;
  IF ( SUBST ( vMiscDirectory3, LONG ( vMiscDirectory3 ) , 1 ) @= '\' ) ;
    vMiscDirectory3 = DELET ( vMiscDirectory3, LONG ( vMiscDirectory3 ), 1 ) ;
  ENDIF;
ENDIF;

#########
# Variables
#########

vTimestamp = TIMST ( NOW(), '\Y\m\d_\h\i\s' ) ;

vArchivePath = vBackupDirectory | '\7-Zip\7z' ;
vArchiveCommand = '"' | vArchivePath | '"' | ' ' | '-tzip a' ;

#############
# Backup Logging
#############
vBackupLogFilePath = '"' | vBackupDirectory | 'Backup Log.txt"' ;

vLogOutput = '***********************************************************************************' ;
vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;
EXECUTECOMMAND ( vLogCommand, 1 ) ;

vStartTime = NOW() ;

### LOG - Start Time

vLogOutput = 'TM1 Backup Process - Started on ' | TIMST ( vStartTime, '\M \D, \Y at \H:\i:\s \p' ) ;
vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;
EXECUTECOMMAND ( vLogCommand, 1 ) ;

### LOG - Compression Status

IF ( FILEEXISTS ( vArchivePath | '.exe' ) = 1 ) ;
  vLogOutput = 'TM1 Backup Process - Compression - Enabled'  ;
  vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;
  EXECUTECOMMAND ( vLogCommand, 1 ) ;

  vLogOutput = 'TM1 Backup Process - Archive Last Day of Month - Enabled' ;
  vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;
  EXECUTECOMMAND ( vLogCommand, 1 ) ;
ELSE;
  vLogOutput = 'TM1 Backup Process - Compression - Disabled' ;
  vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;
  EXECUTECOMMAND ( vLogCommand, 1 ) ;

  vLogOutput = 'TM1 Backup Process - Archive Last Day of Month - Disabled' ;
  vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;
  EXECUTECOMMAND ( vLogCommand, 1 ) ;
ENDIF;

### LOG - Cleanup Logs Status

IF ( vLogDirectory @<> '' & cLogLife @<> '' ) ;
  vLogOutput = 'TM1 Backup Process - Log File Cleanup - Enabled'  ;
  vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;
  EXECUTECOMMAND ( vLogCommand, 1 ) ;

  vLogOutput = 'TM1 Backup Process - Log Files Older than ' | cLogLife | ' Day(s) will be DELETED' ;
  vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;
  EXECUTECOMMAND ( vLogCommand, 1 ) ;
ELSE;
  vLogOutput = 'TM1 Backup Process - Log File Cleanup - Disabled' ;
  vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;
  EXECUTECOMMAND ( vLogCommand, 1 ) ;
ENDIF;

### LOG - Cleanup Backups Status

IF ( cBackupLife @<> '' ) ;
  vLogOutput = 'TM1 Backup Process - Backup Cleanup - Enabled' ;
  vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;
  EXECUTECOMMAND ( vLogCommand, 1 ) ;

  vLogOutput = 'TM1 Backup Process - Backups Older than ' | cBackupLife | ' Day(s) will be DELETED' ;
  vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;
  EXECUTECOMMAND ( vLogCommand, 1 ) ;
ELSE;
  vLogOutput = 'TM1 Backup Process - Backup Cleanup - Disabled' ;
  vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;
  EXECUTECOMMAND ( vLogCommand, 1 ) ;
ENDIF;

#######################
# Set Backup Paths/Directories
#######################

IF ( FILEEXISTS ( vArchivePath | '.exe' ) = 1 ) ;
  vBackupName = vServerName | '_' | vTimestamp | '.zip' ;
  vBackupPath = '"' | vBackupDirectory | vBackupName | '"' ;
ELSE;
  vBackupName = vServerName | '_' | vTimestamp ;
  vBackupDirectory = '"' | vBackupDirectory | vBackupName | '"' ;
  EXECUTECOMMAND ( 'CMD /C MKDIR ' | vBackupDirectory, 1 ) ; 
ENDIF;

###############################
# Data Directory Backup
###############################
vDataDirectory = '"' | vDataDirectory | '"' ;

vDirectoryName = vDataDirectory ;
WHILE ( SCAN ( '\', vDirectoryName ) > 0 ) ;
  vDirectoryName = DELET ( vDirectoryName, 1, SCAN ( '\', vDirectoryName ) ) ;
END;

IF ( FILEEXISTS ( vArchivePath | '.exe' ) = 1 ) ;
  vBackupCommand = 'CMD /C ' | '"' | vArchiveCommand | ' ' | vBackupPath | ' ' | vDataDirectory | '"' ;
ELSE;
  vBackupDirectory = '"' | vBackupDirectory | vBackupName | '\' | vDirectoryName | '"' ;
    EXECUTECOMMAND ( 'CMD /C MKDIR ' | vBackupDirectory, 1 ) ; 
  vBackupCommand = 'CMD /C ROBOCOPY ' | vDataDirectory | ' ' | vBackupDirectory | ' /s /w:0 /r:0' ;
ENDIF;

EXECUTECOMMAND ( vBackupCommand, 1 ) ;

### Output to Log
vLogOutput = 'Successfully Completed - ' | vDirectoryName | ' Directory Backup on ' | TIMST ( NOW(), '\M \D, \Y at \H:\i:\s \p' ) ;
vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;
EXECUTECOMMAND ( vLogCommand, 1 ) ;

###############################
# Miscellaneous Directory 1 Backup
###############################

IF ( vMiscDirectory1 @<> '' ) ;

  vMiscDirectory1 = '"' | vMiscDirectory1 | '"' ;

  vDirectoryName = vMiscDirectory1 ;
  WHILE ( SCAN ( '\', vDirectoryName ) > 0 ) ;
    vDirectoryName = DELET ( vDirectoryName, 1, SCAN ( '\', vDirectoryName ) ) ;
  END;

  IF ( FILEEXISTS ( vArchivePath | '.exe' ) = 1 ) ;
    vBackupCommand = 'CMD /C ' | '"' | vArchiveCommand | ' ' | vBackupPath | ' ' | vMiscDirectory1 | '"' ;
  ELSE;
    vBackupDirectory = '"' | vBackupDirectory | vBackupName | '\' | vDirectoryName | '"' ;
    EXECUTECOMMAND ( 'CMD /C MKDIR ' | vBackupDirectory, 1 ) ; 
    vBackupCommand = 'CMD /C ROBOCOPY ' | vMiscDirectory1 | ' ' | vBackupDirectory | ' /s /w:0 /r:0' ;
  ENDIF;

    EXECUTECOMMAND ( vBackupCommand, 1 ) ;

    ### Output to Log
    vLogOutput = 'Successfully Completed - ' | vDirectoryName | ' Directory Backup on ' | TIMST ( NOW(), '\M \D, \Y at \H:\i:\s \p' ) ;
    vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;

    EXECUTECOMMAND ( vLogCommand, 1 ) ;

ENDIF;

###############################
# Miscellaneous Directory 2 Backup
###############################

IF ( vMiscDirectory2 @<> '' ) ;

  vMiscDirectory2 = '"' | vMiscDirectory2 | '"' ;

  vDirectoryName = vMiscDirectory2 ;
  WHILE ( SCAN ( '\', vDirectoryName ) > 0 ) ;
    vDirectoryName = DELET ( vDirectoryName, 1, SCAN ( '\', vDirectoryName ) ) ;
  END;

  IF ( FILEEXISTS ( vArchivePath | '.exe' ) = 1 ) ;
    vBackupCommand = 'CMD /C ' | '"' | vArchiveCommand | ' ' | vBackupPath | ' ' | vMiscDirectory2 | '"' ;
  ELSE;
    vBackupDirectory = '"' | vBackupDirectory | vBackupName | '\' | vDirectoryName | '"' ;
    EXECUTECOMMAND ( 'CMD /C MKDIR ' | vBackupDirectory, 1 ) ; 
    vBackupCommand = 'CMD /C ROBOCOPY ' | vMiscDirectory2 | ' ' | vBackupDirectory | ' /s /w:0 /r:0' ;
  ENDIF;

    EXECUTECOMMAND ( vBackupCommand, 1 ) ;

    ### Output to Log
    vLogOutput = 'Successfully Completed - ' | vDirectoryName | ' Directory Backup on ' | TIMST ( NOW(), '\M \D, \Y at \H:\i:\s \p' ) ;
    vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;

    EXECUTECOMMAND ( vLogCommand, 1 ) ;

ENDIF;

###############################
# Miscellaneous Directory 3 Backup
###############################

IF ( vMiscDirectory3 @<> '' ) ;

  vMiscDirectory3 = '"' | vMiscDirectory3 | '"' ;

  vDirectoryName = vMiscDirectory3 ;
  WHILE ( SCAN ( '\', vDirectoryName ) > 0 ) ;
    vDirectoryName = DELET ( vDirectoryName, 1, SCAN ( '\', vDirectoryName ) ) ;
  END;

  IF ( FILEEXISTS ( vArchivePath | '.exe' ) = 1 ) ;
    vBackupCommand = 'CMD /C ' | '"' | vArchiveCommand | ' ' | vBackupPath | ' ' | vMiscDirectory3 | '"' ;
  ELSE;
    vBackupDirectory = '"' | vBackupDirectory | vBackupName | '\' | vDirectoryName | '"' ;
    EXECUTECOMMAND ( 'CMD /C MKDIR ' | vBackupDirectory, 1 ) ; 
    vBackupCommand = 'CMD /C ROBOCOPY ' | vMiscDirectory3 | ' ' | vBackupDirectory | ' /s /w:0 /r:0' ;
  ENDIF;

    EXECUTECOMMAND ( vBackupCommand, 1 ) ;

    ### Output to Log
    vLogOutput = 'Successfully Completed - ' | vDirectoryName | ' Directory Backup on ' | TIMST ( NOW(), '\M \D, \Y at \H:\i:\s \p' ) ;
    vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;

    EXECUTECOMMAND ( vLogCommand, 1 ) ;

ENDIF;

########################
# Cleanup Log Directory
########################

### NOTE: Leave Log Directory or Log Life fields blank in control cube to not cleanup log files

IF ( vLogDirectory @<> '' ) ;

  IF ( cLogLife @<> '' ) ;

    IF ( SUBST ( cLogLife, 1, 1 ) @= '-' ) ;
    ELSE;
      vLogLife = '-' | cLogLife ;
    ENDIF;

    ### Remove TM1S<Timestamped> logs older than log life
    vCommand = 'CMD /C "FORFILES /m "TM1S??????????????.*" /d ' | vLogLife | ' /p ' | '"' | vLogDirectory | '"' | ' /C "CMD /C DEL /Q @PATH""' ;
    EXECUTECOMMAND ( vCommand, 1 ) ;

    ### Remove TM1 Process Error Files older than Log Life definition
    vCommand = 'CMD /C "FORFILES /m "TM1ProcessError*" /d ' | vLogLife | ' /p ' | '"' | vLogDirectory | '"' | ' /C "CMD /C DEL /Q @PATH""' ;
    EXECUTECOMMAND ( vCommand, 1 ) ;

    ### Output to Log
    vLogOutput = 'Successfully Removed Log Files Older than ' | cLogLife | ' day(s) on ' | TIMST ( NOW(), '\M \D, \Y at \H:\i:\s \p' ) ;
    vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;
    EXECUTECOMMAND ( vLogCommand, 1 ) ;


  ENDIF;

ENDIF;

########################################
# Archive Last Day in Month Backups (Only for ZIP FIles)
########################################

### NOTE: Due to code and size constaints we will not archive the last day of each month's backup unless the backups are compressed into a ZIP format

IF ( FILEEXISTS ( vArchivePath | '.exe' ) = 1 ) ;

  ### Create Archive Directory Under Backup Directory

  vBackupArchiveDirectory = '"' | vBackupDirectory | 'Archive\"' ;
  vCommand = 'CMD /C MKDIR ' | vBackupArchiveDirectory ;
  EXECUTECOMMAND ( vCommand, 1 ) ;

  ### Copy Files into Archive Directory

  vSearchDirectory = '"' | SUBST ( vBackupDirectory, 1, LONG ( vBackupDirectory ) - 1 ) | '"' ;

  ### Jan
  vCommand = 'CMD /C "FORFILES /m "*_????0131_??????.zip" /p ' | vSearchDirectory | ' /C "CMD /C COPY @PATH \' | vBackupArchiveDirectory | '"' ;
  EXECUTECOMMAND ( vCommand, 1 ) ;

  ### Feb
  vCommand = 'CMD /C "FORFILES /m "*_????0228_??????.zip" /p ' | vSearchDirectory | ' /C "CMD /C COPY @PATH \' | vBackupArchiveDirectory | '"' ;
  EXECUTECOMMAND ( vCommand, 1 ) ;

  ### Mar
  vCommand = 'CMD /C "FORFILES /m "*_????0331_??????.zip" /p ' | vSearchDirectory | ' /C "CMD /C COPY @PATH \' | vBackupArchiveDirectory | '"' ;
  EXECUTECOMMAND ( vCommand, 1 ) ;

  ### Apr
  vCommand = 'CMD /C "FORFILES /m "*_????0430_??????.zip" /p ' | vSearchDirectory | ' /C "CMD /C COPY @PATH \' | vBackupArchiveDirectory | '"' ;
  EXECUTECOMMAND ( vCommand, 1 ) ;

  ### May
  vCommand = 'CMD /C "FORFILES /m "*_????0531_??????.zip" /p ' | vSearchDirectory | ' /C "CMD /C COPY @PATH \' | vBackupArchiveDirectory | '"' ;
  EXECUTECOMMAND ( vCommand, 1 ) ;

  ### Jun
  vCommand = 'CMD /C "FORFILES /m "*_????0630_??????.zip" /p ' | vSearchDirectory | ' /C "CMD /C COPY @PATH \' | vBackupArchiveDirectory | '"' ;
  EXECUTECOMMAND ( vCommand, 1 ) ;

  ### Jul
  vCommand = 'CMD /C "FORFILES /m "*_????0731_??????.zip" /p ' | vSearchDirectory | ' /C "CMD /C COPY @PATH \' | vBackupArchiveDirectory | '"' ;
  EXECUTECOMMAND ( vCommand, 1 ) ;

  ### Aug
  vCommand = 'CMD /C "FORFILES /m "*_????0831_??????.zip" /p ' | vSearchDirectory | ' /C "CMD /C COPY @PATH \' | vBackupArchiveDirectory | '"' ;
  EXECUTECOMMAND ( vCommand, 1 ) ;

  ### Sep
  vCommand = 'CMD /C "FORFILES /m "*_????0930_??????.zip" /p ' | vSearchDirectory | ' /C "CMD /C COPY @PATH \' | vBackupArchiveDirectory | '"' ;
  EXECUTECOMMAND ( vCommand, 1 ) ;

  ### Oct
  vCommand = 'CMD /C "FORFILES /m "*_????1031_??????.zip" /p ' | vSearchDirectory | ' /C "CMD /C COPY @PATH \' | vBackupArchiveDirectory | '"' ;
  EXECUTECOMMAND ( vCommand, 1 ) ;

  ### Nov
  vCommand = 'CMD /C "FORFILES /m "*_????1130_??????.zip" /p ' | vSearchDirectory | ' /C "CMD /C COPY @PATH \' | vBackupArchiveDirectory | '"' ;
  EXECUTECOMMAND ( vCommand, 1 ) ;

  ### Dec
  vCommand = 'CMD /C "FORFILES /m "*_????1231_??????.zip" /p ' | vSearchDirectory | ' /C "CMD /C COPY @PATH \' | vBackupArchiveDirectory | '"' ;


ENDIF;

############################
# Cleanup Backup Directory
############################

### NOTE: Leave Backup Life field blank in the Variables cube to not cleanup the Backup Files

IF ( cBackupLife @<> '' ) ;

  vSearchDirectory = '"' | SUBST ( vBackupDirectory, 1, LONG ( vBackupDirectory ) - 1 ) | '"' ;

  IF ( SUBST ( cBackupLife, 1, 1 ) @= '-' ) ;
  ELSE;
    vBackupLife = '-' | cBackupLife ;
  ENDIF;

  IF ( FILEEXISTS ( vArchivePath | '.exe' ) = 1 ) ;
    vCommand = 'CMD /C "FORFILES /m "*.zip" /d ' | vBackupLife | ' /p ' | vSearchDirectory | ' /C "CMD /C DEL /Q @PATH""' ;
    EXECUTECOMMAND ( vCommand, 1 ) ;
  ELSE;
    vCommand = 'CMD /C "FORFILES /m "' | vServerName | '_????????_??????" /d ' | vBackupLife | ' /p ' | vSearchDirectory | ' /C "CMD /C IF @ISDIR == TRUE RMDIR /Q /S @PATH""' ;
    EXECUTECOMMAND ( vCommand, 1 ) ;
  ENDIF;

  ### Output to Log
  vLogOutput = 'Successfully Cleaned Up Backups older than ' | cBackupLife | ' Day(s) on ' | TIMST ( NOW(), '\M \D, \Y at \H:\i:\s \p' ) ;
  vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;
  EXECUTECOMMAND ( vLogCommand, 1 ) ;

ENDIF;

##############
# Backup Logging
##############

vEndTime = NOW() ;
vDuration = vEndTime - vStartTime ;

vLogOutput = 'TM1 Backup Process - Completed on ' | TIMST ( vEndTime, '\M \D, \Y at \H:\i:\s \p' ) ;
vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;

EXECUTECOMMAND ( vLogCommand, 1 ) ;

vLogOutput = 'TM1 Backup Process - Completed in ' | TIMST ( vDuration, '\i minutes and \s seconds' ) ;
vLogCommand = 'CMD /C ECHO ' | vLogOutput | ' >> ' | vBackupLogFilePath ;

EXECUTECOMMAND ( vLogCommand, 1 ) ;
573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,3

#****Begin: Generated Statements***
#****End: Generated Statements****
575,33

#****Begin: Generated Statements***
#****End: Generated Statements****

#=========================== FINAL CODE IN EPILOG =========================================
sNow = TIMST( NOW,'\M \D, \Y at \H \p \i min \s sec' ) ;
nNowEnd = NOW ;
nDelta = ( nNowEnd - nNowStart ) ;
nDuration = nDelta * 1440 ;
nDurMin = INT( nDuration ) ;
IF( nDurMin = 0 ) ;
  nDurSec = ROUND( nDuration * 60 ) ;
ELSE ;
  nDurSec = ROUND( MOD( nDuration , nDurMin ) * 60 ) ;
ENDIF ;
sDuration = NUMBERTOSTRING( nDurMin ) | ' min, ' | NUMBERTOSTRING( nDurSec ) | ' sec' ;
CELLPUTS( sDuration , cubProcessStatistics , sLine , proProcess , sDate , 'Duration' ) ;
CELLPUTS( sDuration , cubProcessStatistics , sLine , proProcess , 'Latest' , 'Duration' ) ;
CELLPUTS( sNow , cubProcessStatistics , sLine , proProcess , sDate , 'End Time' ) ;
CELLPUTS( sNow , cubProcessStatistics , sLine , proProcess , 'Latest' , 'End Time' ) ;
CELLPUTN( nRecordCount , cubProcessStatistics , sLine , proProcess , sDate , 'Record Count' ) ;
CELLPUTN( nRecordCount , cubProcessStatistics , sLine , proProcess , 'Latest' , 'Record Count' ) ;
CELLPUTN( nRecordProcess , cubProcessStatistics , sLine , proProcess , sDate , 'Processed Records' ) ;
CELLPUTN( nRecordProcess , cubProcessStatistics , sLine , proProcess , 'Latest' , 'Processed Records' ) ;
CELLPUTN( nRecordSkip , cubProcessStatistics , sLine , proProcess , sDate , 'Skipped Records' ) ;
CELLPUTN( nRecordSkip , cubProcessStatistics , sLine , proProcess , 'Latest' , 'Skipped Records' ) ;
#===================== Uncomment if Target Total is used within process =============
#CELLPUTN( nSourceTotal , cubProcessStatistics , sLine , proProcess , sDate , 'Source Total' ) ;
#CELLPUTN( nSourceTotal , cubProcessStatistics , sLine , proProcess , 'Latest' , 'Source Total' ) ;
#nTargetTotal = CELLGETN( cubTarget , dim1 , dim2 , dim3 , dim4 ) ;
#CELLPUTN( nTargetTotal , cubProcessStatistics , sLine , proProcess , sDate , 'Target Total' ) ;
#CELLPUTN( nTargetTotal , cubProcessStatistics , sLine , proProcess , 'Latest' , 'Target Total' ) ;
#==========================================================================================
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
