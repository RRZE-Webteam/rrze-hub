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
        add_action('rest_api_init', [$this, 'registerPersonRoute']);
    }

    public function registerPersonRoute(){
        register_rest_route( 'rrze-hub/api/v1', '/person', [
            [
                'methods'  => 'GET',
                'callback' => [$this, 'getPerson'],
                'args' => [
                    'filterBy' => [
                        'description' => __('filterBy is used to define the filter by ID, name or department', 'rrze-hub'),
                        'type' => 'string',
                        'enum' => ['person_id', 'name', 'dep_univisID'],
                        'validate_callback' => [$this, 'valStr']
                    ],
                    'filterValue' => [
                        'description' => __('filterValue is used to set the value which is used for filterBy', 'rrze-hub'),
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
                    ''                    
                ]
            ],
        ]);
    }

    public function getPerson($args){
        $this->dbfuncs = new DBFunctions($args);
        $data = $this->dbfuncs->getPerson($args);
        $data = rest_ensure_response($data);

        return $data;
    }

    public function valStr($value, $request, $param){
        if (!is_string($value)) {
            return new WP_Error('rest_invalid_param', $param . ' ' . __('must be a string.', 'rrze-hub'), ['status' => 400]);
        }
    }

}
