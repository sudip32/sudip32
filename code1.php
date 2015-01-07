<?php defined('MOODLE_INTERNAL') || die();
 $configuration = array (
  'siteidentifier' => NULL,
  'stores' => 
  array (
    'default_application' => 
    array (
      'name' => 'default_application',
      'plugin' => 'file',
      'configuration' => 
      array (
      ),
      'features' => 14,
      'modes' => 3,
      'default' => true,
    ),
    'default_session' => 
    array (
      'name' => 'default_session',
      'plugin' => 'session',
      'configuration' => 
      array (
      ),
      'features' => 14,
      'modes' => 2,
      'default' => true,
    ),
    'default_request' => 
    array (
      'name' => 'default_request',
      'plugin' => 'static',
      'configuration' => 
      array (
      ),
      'features' => 14,
      'modes' => 4,
      'default' => true,
    ),
  ),
  'modemappings' => 
  array (
    0 => 
    array (
      'mode' => 1,
      'store' => 'default_application',
      'sort' => -1,
    ),
    1 => 
    array (
      'mode' => 2,
      'store' => 'default_session',
      'sort' => -1,
    ),
    2 => 
    array (
      'mode' => 4,
      'store' => 'default_request',
      'sort' => -1,
    ),
  ),
  'definitions' => 
  array (
    'core/string' => 
    array (
      'mode' => 1,
      'simplekeys' => true,
      'simpledata' => true,
      'persistent' => true,
      'persistentmaxsize' => 30,
      'component' => 'core',
      'area' => 'string',
    ),
    'core/databasemeta' => 
    array (
      'mode' => 1,
      'requireidentifiers' => 
      array (
        0 => 'dbfamily',
      ),
      'persistent' => true,
      'persistentmaxsize' => 15,
      'component' => 'core',
      'area' => 'databasemeta',
    ),
    'core/eventinvalidation' => 
    array (
      'mode' => 1,
      'persistent' => true,
      'requiredataguarantee' => true,
      'simpledata' => true,
      'component' => 'core',
      'area' => 'eventinvalidation',
    ),
    'core/questiondata' => 
    array (
      'mode' => 1,
      'simplekeys' => true,
      'requiredataguarantee' => false,
      'datasource' => 'question_finder',
      'datasourcefile' => 'question/engine/bank.php',
      'component' => 'core',
      'area' => 'questiondata',
    ),
    'core/htmlpurifier' => 
    array (
      'mode' => 1,
      'component' => 'core',
      'area' => 'htmlpurifier',
    ),
    'core/config' => 
    array (
      'mode' => 1,
      'persistent' => true,
      'simpledata' => true,
      'component' => 'core',
      'area' => 'config',
    ),
    'core/groupdata' => 
    array (
      'mode' => 1,
      'simplekeys' => true,
      'simpledata' => true,
      'persistent' => true,
      'persistmaxsize' => 2,
      'component' => 'core',
      'area' => 'groupdata',
    ),
    'core/calendar_subscriptions' => 
    array (
      'mode' => 1,
      'simplekeys' => true,
      'simpledata' => true,
      'persistent' => true,
      'component' => 'core',
      'area' => 'calendar_subscriptions',
    ),
    'core/yuimodules' => 
    array (
      'mode' => 1,
      'component' => 'core',
      'area' => 'yuimodules',
    ),
    'core/plugintypes' => 
    array (
      'mode' => 1,
      'simplekeys' => true,
      'simpledata' => true,
      'persistent' => true,
      'persistmaxsize' => 2,
      'component' => 'core',
      'area' => 'plugintypes',
    ),
    'core/pluginlist' => 
    array (
      'mode' => 1,
      'simplekeys' => true,
      'simpledata' => true,
      'persistent' => true,
      'persistentmaxsize' => 2,
      'component' => 'core',
      'area' => 'pluginlist',
    ),
    'core/plugininfo_base' => 
    array (
      'mode' => 1,
      'simplekeys' => true,
      'simpledata' => true,
      'persistent' => true,
      'persistentmaxsize' => 2,
      'component' => 'core',
      'area' => 'plugininfo_base',
    ),
    'core/plugininfo_mod' => 
    array (
      'mode' => 1,
      'simplekeys' => true,
      'simpledata' => true,
      'persistent' => true,
      'persistentmaxsize' => 1,
      'component' => 'core',
      'area' => 'plugininfo_mod',
    ),
    'core/plugininfo_block' => 
    array (
      'mode' => 1,
      'simplekeys' => true,
      'simpledata' => true,
      'persistent' => true,
      'persistentmaxsize' => 1,
      'component' => 'core',
      'area' => 'plugininfo_block',
    ),
    'core/plugininfo_filter' => 
    array (
      'mode' => 1,
      'simplekeys' => true,
      'simpledata' => true,
      'persistent' => true,
      'persistentmaxsize' => 1,
      'component' => 'core',
      'area' => 'plugininfo_filter',
    ),
    'core/plugininfo_repository' => 
    array (
      'mode' => 1,
      'simplekeys' => true,
      'simpledata' => true,
      'persistent' => true,
      'persistentmaxsize' => 1,
      'component' => 'core',
      'area' => 'plugininfo_repository',
    ),
    'core/plugininfo_portfolio' => 
    array (
      'mode' => 1,
      'simplekeys' => true,
      'simpledata' => true,
      'persistent' => true,
      'persistentmaxsize' => 1,
      'component' => 'core',
      'area' => 'plugininfo_portfolio',
    ),
    'core/coursecattree' => 
    array (
      'mode' => 1,
      'persistent' => true,
      'invalidationevents' => 
      array (
        0 => 'changesincoursecat',
      ),
      'component' => 'core',
      'area' => 'coursecattree',
    ),
    'core/coursecat' => 
    array (
      'mode' => 2,
      'persistent' => true,
      'invalidationevents' => 
      array (
        0 => 'changesincoursecat',
        1 => 'changesincourse',
      ),
      'ttl' => 600,
      'component' => 'core',
      'area' => 'coursecat',
    ),
    'core/coursecatrecords' => 
    array (
      'mode' => 4,
      'simplekeys' => true,
      'persistent' => true,
      'invalidationevents' => 
      array (
        0 => 'changesincoursecat',
      ),
      'component' => 'core',
      'area' => 'coursecatrecords',
    ),
    'core/coursecontacts' => 
    array (
      'mode' => 1,
      'persistent' => true,
      'simplekeys' => true,
      'component' => 'core',
      'area' => 'coursecontacts',
    ),
    'core/repositories' => 
    array (
      'mode' => 4,
      'persistent' => true,
      'component' => 'core',
      'area' => 'repositories',
    ),
    'core/externalbadges' => 
    array (
      'mode' => 1,
      'simplekeys' => true,
      'ttl' => 3600,
      'component' => 'core',
      'area' => 'externalbadges',
    ),
  ),
  'definitionmappings' => 
  array (
  ),
  'locks' => 
  array (
    'default_file_lock' => 
    array (
      'name' => 'cachelock_file_default',
      'type' => 'cachelock_file',
      'dir' => 'filelocks',
      'default' => true,
    ),
  ),
);