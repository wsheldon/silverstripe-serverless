<?php

use SilverStripe\HybridSessions\HybridSession;
use SilverStripe\Core\Environment;

define('AWS_REGION', Environment::getEnv('AWS_REGION_HOLDER'));

HybridSession::init(Environment::getEnv('SS_SESSION_KEY'));

