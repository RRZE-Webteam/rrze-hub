<?php

namespace RRZE\Hub;

defined( 'ABSPATH' ) || exit;

use RRZE\Hub\DBFunctions;


// 'filterBy' => 'person_id',
// 'filterValue' => $this->atts['univisid']


/*
* Endpoints: rrze-hub/api/v1/person?filterBy= &filterValue= &orderBy=
*/


// https://www.nickless.test.rrze.fau.de/wp-16/wp-json/rrze-hub/api/v1/person?filterBy=person_id&filterValue=21690112

class RESTAPI {

    protected $dbfuncs;

    public function __construct() {
        add_action('rest_api_init', [$this, 'registerRoutes']);

        $this->setUnivisID('100100');
    }

    public function registerRoutes(){
        $aEndpoint = [
            'univisID' => 'setUnivisID',
            'person' => 'getPerson', 
            'lecture' => 'getLecture', 
            // 'publication' => 'getPublication',
        ];

        foreach ($aEndpoint as $endpoint => $func){
            register_rest_route( 'rrze-hub/api/v1', '/' . $endpoint, [
                [
                    'methods'  => 'GET',
                    'callback' => [$this, $func],
                    'args' => $this->getRouteArgs($endpoint),
                    'permission_callback' => function() { return ''; } // we don't need any authorization for this endpoint - if needed, see: https://stackoverflow.com/questions/47455745/wordpress-api-permission-callback-check-if-user-is-logged-in
                ],
            ]);
        }
    }

    public function getRouteArgs($endpoint){
        $aRet = [
            'univisID' => [
                'sID' => [
                    'description' => __('sID is the department\'s UnivIS ID', 'rrze-hub'),
                    'type' => 'string',
                    'required' => TRUE,
                    'validate_callback' => [$this, 'valStr']
                ],
            ],
            'person' => [
                'filterBy' => [
                    'description' => __('filterBy is used to define the filter by ID, name or department', 'rrze-hub'),
                    'type' => 'string',
                    'required' => TRUE,
                    'default' => 'person_id',
                    'enum' => ['person_id', 'name', 'dep_univisID'],
                    'validate_callback' => [$this, 'valStr']
                ],
                'filterValue' => [
                    'description' => __('filterValue is used to set the value which is used for filterBy', 'rrze-hub'),
                    'required' => TRUE,
                    'type' => 'string',
                    'validate_callback' => [$this, 'valStr']
                ],
                'orderBy' => [
                    'description' => __('orderBy is used to sort the results', 'rrze-hub'),
                    'type' => 'string',
                    'enum' => ['lastname', 'position_order, lastname', 'position_order,lastname'],
                    'validate_callback' => [$this, 'valStr']
                ],
                'groupBy' => [
                    'description' => __('groupBy is used to group the results', 'rrze-hub'),
                    'type' => 'string',
                    'enum' => ['department', 'letter', 'position'],
                    'validate_callback' => [$this, 'valStr']
                ],
                'showJobs' => [
                    'description' => __('showJobs is used to filter by job positions', 'rrze-hub'),
                    'type' => 'string',
                    'validate_callback' => [$this, 'valStr']
                ],
                'ignoreJobs' => [
                    'description' => __('ignoreJobs is used to filter by job positions', 'rrze-hub'),
                    'type' => 'string',
                    'validate_callback' => [$this, 'valStr']
                ],
            ],
            'lecture' => [
                'filter' => [
                    'description' => __('filter is used to define the filter by deparment\'s univIS ID, lecture_person_univisID, lecture_person_name, lecture_univisID, lecture_type_short, leclanguage_short, earlystudy, guest AND / OR ects', 'rrze-hub'),
                    // 'type' => 'array', // BUG => wie kann http_build_query encoded string auf array geprüft werden?
                    // 'validate_callback' => [$this, 'valArr'] // BUG => ist weder array noch "json-array"
                ],
                'orderBy' => [
                    'description' => __('orderBy is used to sort the results', 'rrze-hub'),
                    'type' => 'string',
                    // 'enum' => [], // 2DO: 'anyOf' nutzen. Siehe https://developer.wordpress.org/rest-api/extending-the-rest-api/schema/ 
                    'validate_callback' => [$this, 'valStr']
                ],
                'groupBy' => [
                    'description' => __('groupBy is used to group the results', 'rrze-hub'),
                    'type' => 'string',
                    'enum' => ['lecture_type'],
                    'validate_callback' => [$this, 'valStr']
                ],
            ],
        ];

        return $aRet[$endpoint];
    }

    public function isNewUnivisID($sID){
        global $wpdb;

        $ID = $wpdb->get_var($wpdb->prepare("SELECT ID FROM rrze_hub_univis WHERE sUnivisID = %s", $sID));
        if ($wpdb->last_error) {
            echo json_encode($wpdb->last_error);
            exit;
        }

        return is_null($ID);
    }



    public function setUnivisID($sID){
        // check if $sID is not already stored in db
        if ($this->isNewUnivisID($sID)) {
            // check if $sID returns valid info 
            // store and trigger Sync to prefetch data
        }
    }


    public function getPerson($args){
        $this->dbfuncs = new DBFunctions($args);
        $data = $this->dbfuncs->getPerson($args);
        $data = rest_ensure_response($data);

        return $data;
    }

    public function getLecture($args){
        $this->dbfuncs = new DBFunctions($args);
        $data = $this->dbfuncs->getLecture($args);
        $data = rest_ensure_response($data);

        return $data;
    }

    public function valStr($value, $request, $param){
        if (!is_string($value)) {
            return new WP_Error('rest_invalid_param', $param . ' ' . __('must be a string.', 'rrze-hub'), ['status' => 400]);
        }
    }

    public function valArr($value, $request, $param){
        if (!is_array(json_decode($value))) {
            return new WP_Error('rest_invalid_param', $param . ' ' . __('must be an URL encoded array.', 'rrze-hub'), ['status' => 400]);
        }
    }

}
