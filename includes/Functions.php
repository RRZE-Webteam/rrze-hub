<?php

namespace RRZE\Hub;

defined('ABSPATH') || exit;


class Functions{
    protected $pluginFile;


    public function __construct($pluginFile) {
    }


    public function onLoaded() {
    }


        // tests:
        // $aAtts = [
        //     'univisid' => '40014582',
        //     // 'name' => 'WIESE,wolfgang'
        // ];


        // $test = $this->getPerson($aAtts);

        // echo '<pre>';
        // var_dump($test);
        // exit;



    public function getPerson($aAtts){
        global $wpdb;

        $aRet = [];
        $sClause = '';

        if (!empty($aAtts['univisid'])){
            // person by its univis ID
            $prepare_vals = [
                $aAtts['univisid']
            ];
            $sClause = "person_id = %s";

            // echo 'by ID<br>';

        }elseif(!empty($aAtts['name'])){
            // person by its fullname (= lastname,firstname)
            $parts = explode(',', strtolower($aAtts['name']));
            $prepare_vals = [
                !empty($parts[0]) ? trim($parts[0]) : '',
                !empty($parts[1]) ? trim($parts[1]) : ''
            ];
            $sClause = "LOWER(lastname) = %s AND LOWER(firstname) = %s";

            // echo 'by name<br>';
        }

        if (!empty($sClause)){
            $rows = $wpdb->get_results($wpdb->prepare("SELECT * FROM getPersons WHERE " . $sClause, $prepare_vals), ARRAY_A);
            if ($wpdb->last_error){
                echo json_encode($wpdb->last_error);
                exit;
            }

            if (!empty($rows[0])){
                $aRet = [
                    'title' => $rows[0]['title'],
                    'atitle' => $rows[0]['atitle'],
                    'firstname' => $rows[0]['firstname'],
                    'lastname' => $rows[0]['lastname'],
                    'work' => $rows[0]['work'],
                    'organization' => $rows[0]['organization'],
                    'department' => $rows[0]['department'],
                    'locations' => [],
                    'officehours' => []
                ];
                foreach ($rows as $row) {
                    $aRet['locations'][] = [
                        'tel' => $row['tel'],
                        'tel_call' => $row['tel_call'],
                        'mobile' => $row['mobile'],
                        'mobile_call' => $row['mobile_call'],
                        'street' => $row['street'],
                        'city' => $row['city'],
                        'office' => $row['office']
                    ];
                    $aRet['officehours'][] = [
                        'repeat' => $row['repeat'],
                        'starttime' => $row['starttime'],
                        'endtime' => $row['endtime'],
                        'office' => $row['officehours_office'],
                        'comment' => $row['comment']
                    ];
                }
                $aRet['locations'] = array_unique($aRet['locations'], SORT_REGULAR);
                $aRet['officehours'] = array_unique($aRet['officehours'], SORT_REGULAR);
            }
        }

        return $aRet;
    }
}
