<?php

use SilverStripe\HybridSessions\HybridSession;
use SilverStripe\Control\Director;

define('AWS_REGION', 'us-east-1');
define('AWS_BUCKET_NAME', 'wilsonsheldon.name');
define('SS_SESSION_KEY', 'adsfadsfasdfasdfasdf');

global $databaseConfig;
$databaseConfig = [
    "type" => "MySQLDatabase",
    "server" => "wilsontest.cyzgvcttarhk.us-east-1.rds.amazonaws.com",
    "username" => 'admin',
    "password" => 'admin123',
    "database" => 'breftest',

];
Director::isLive();

HybridSession::init(SS_SESSION_KEY);

