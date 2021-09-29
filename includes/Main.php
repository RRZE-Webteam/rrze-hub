<?php

namespace RRZE\Hub;

defined('ABSPATH') || exit;

use RRZE\Hub\Settings;
use function RRZE\Hub\Config\deleteLogfile;


class Main {

    protected $pluginFile;


    public function __construct($pluginFile) {
    }

    public function onLoaded() {
        add_action('wp_enqueue_scripts', [$this, 'enqueueScripts']);

        $settings = new Settings($this->pluginFile);
        $settings->onLoaded();

        $sync = new Sync($this->pluginFile);
        $sync->onLoaded();

        $restAPI = new RESTAPI();

        // add_action( 'update_option_rrze-hub', [$this, 'switchTask'] );
        add_filter( 'pre_update_option_rrze-hub',  [$this, 'switchTask'], 10, 1 );

        add_action( 'rrze-hub_cronjob', [$this, 'runCronjob'] );
    }

    public function enqueueScripts() {
        wp_register_style('rrze-hub', plugins_url('assets/css/plugin.css', plugin_basename($this->pluginFile)));
    }


    public function switchTask($options) {
        if (isset($_GET['del'])){
            deleteLogfile();
        }else{
            $this->setCronjob();
        }

        return $options;
    }

    public function runCronjob() {
        $functions = new Functions($this->pluginFile);
        $functions->doSync();
    }

    public function setCronjob() {
        date_default_timezone_set( 'Europe/Berlin' );

        $options = get_option( 'rrze-hub' );

        if ( $options['sync_autosync'] != 'on' ) {
            wp_clear_scheduled_hook( 'rrze-hub_cronjob' );
            return;
        }

        $nextcron = 0;
        switch( $options['sync_frequency'] ){
            case 'daily' : $nextcron = 86400;
                break;
            case 'twicedaily' : $nextcron = 43200;
                break;
        }

        $nextcron += time();
        wp_clear_scheduled_hook( 'rrze-hub_cronjob' );
        wp_schedule_event( $nextcron, $options['sync_frequency'], 'rrze-hub_cronjob' );

        $timestamp = wp_next_scheduled( 'rrze-hub_cronjob' );
        $message = __( 'Next automatically synchronization:', 'rrze-hub' ) . ' ' . date( 'd.m.Y H:i:s', $timestamp );
        add_settings_error( 'AutoSyncComplete', 'autosynccomplete', $message , 'updated' );
        settings_errors();
    }


}
