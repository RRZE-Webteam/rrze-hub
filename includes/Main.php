<?php

namespace RRZE\Hub;

defined('ABSPATH') || exit;

use RRZE\Hub\Settings;


class Main {

    protected $pluginFile;


    public function __construct($pluginFile) {
    }

    public function onLoaded() {
        add_action('wp_enqueue_scripts', [$this, 'enqueueScripts']);

        // Settings-Klasse wird instanziiert.
        $settings = new Settings($this->pluginFile);
        $settings->onLoaded();

        $functions = new Functions($this->pluginFile);
        $functions->onLoaded();

        add_action( 'update_option_rrze-hub', [$this, 'setCronjob'] );
        add_action( 'rrze-hub_cronjob', [$this, 'runCronjob'] );
    }

    public function enqueueScripts() {
        wp_register_style('rrze-hub', plugins_url('assets/css/plugin.css', plugin_basename($this->pluginFile)));
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
