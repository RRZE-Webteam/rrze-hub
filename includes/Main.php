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

    }

    public function enqueueScripts() {
        wp_register_style('rrze-hub', plugins_url('assets/css/plugin.css', plugin_basename($this->pluginFile)));
    }


}
