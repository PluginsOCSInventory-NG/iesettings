<?php

/**
 * This function is called on installation and is used to create database schema for the plugin
 */
function extension_install_iesettings()
{
    $commonObject = new ExtensionCommon;

    $commonObject -> sqlQuery("CREATE TABLE IF NOT EXISTS `iesettings` (
                              `ID` INT(11) NOT NULL AUTO_INCREMENT,
                              `HARDWARE_ID` INT(11) NOT NULL,
                              `VERSION` VARCHAR(255) DEFAULT NULL,
                              `LASTSESSION` VARCHAR(255) DEFAULT NULL,
                              `SID` VARCHAR(255) DEFAULT NULL,
                              `PROXYENABLE` VARCHAR(255) DEFAULT NULL,
                              `AUTOCONFIGURL` VARCHAR(255) DEFAULT NULL,
                              `PROXYSERVER` VARCHAR(255) DEFAULT NULL,
                              `PROXYOVERRIDE` VARCHAR(255) DEFAULT NULL,
                              PRIMARY KEY  (`ID`,`HARDWARE_ID`)
                              ) ENGINE=INNODB;");
}

/**
 * This function is called on removal and is used to destroy database schema for the plugin
 */
function extension_delete_iesettings()
{
    $commonObject = new ExtensionCommon;
    $commonObject -> sqlQuery("DROP TABLE `iesettings`;");
}

/**
 * This function is called on plugin upgrade
 */
function extension_upgrade_iesettings()
{

}
