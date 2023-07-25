update ist_goil_audit.as_subjects
set subject=replace(subject,'&oldenvironment','&newenvironment') ,
rv_service='&servicevalue',
rv_network='&network_value', 
rv_daemon='&daemonvalue';

