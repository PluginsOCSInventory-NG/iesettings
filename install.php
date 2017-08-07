<?php
function plugin_version_iesettings()
{
return array('name' => 'Internet Explorer settings',
'version' => '1.1',
'author'=> 'Community, Frank BOURDEAU',
'license' => 'GPLv2',
'verMinOcs' => '2.2');
}

function plugin_init_iesettings()
{
$object = new plugins;
$object -> add_cd_entry("iesettings","other");

$object -> sql_query("CREATE TABLE IF NOT EXISTS `iesettings` (
  `ID` INT(11) NOT NULL AUTO_INCREMENT,
  `HARDWARE_ID` INT(11) NOT NULL,
  `VERSION` VARCHAR(255) DEFAULT NULL,
  `LASTSESSION` VARCHAR(255) DEFAULT NULL,
  `SID` VARCHAR(255) DEFAULT NULL,
  `PROXYENABLE` INTEGER DEFAULT NULL,
  `AUTOCONFIGURL` VARCHAR(255) DEFAULT NULL,
  `PROXYSERVER` VARCHAR(15) DEFAULT NULL,
  `PROXYOVERRIDE` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY  (`ID`,`HARDWARE_ID`)
) ENGINE=INNODB;");

}

function plugin_delete_iesettings()
{
$object = new plugins;
$object->del_cd_entry("iesettings");
$object->sql_query("DROP TABLE `iesettings`");

}

?>
