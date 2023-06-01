<?php  // Moodle configuration file

unset($CFG);
global $CFG;
$CFG = new stdClass();

$CFG->dbtype    = getenv('dbtype');
$CFG->dblibrary = 'native';
$CFG->dbhost    = getenv('dbhost');
$CFG->dbname    = getenv('dbname');
$CFG->dbuser    = getenv('dbuser');
$CFG->dbpass    = getenv('dbpass');
$CFG->prefix    = 'mdl_';
$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbport' => '',
  'dbsocket' => '',
  'dbcollation' => 'utf8mb4_general_ci',
);

$CFG->wwwroot   = getenv('protocol').'://'.getenv('host');
$CFG->dataroot  = '/var/www/moodledata';
$CFG->admin     = 'admin';
$CFG->sslproxy  = getenv('sslproxy');



#$CFG->localcachedir = '/var/www/moodledata/cache';
$CFG->directorypermissions = 02777;

require_once(__DIR__ . '/lib/setup.php');

// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!
