<?php

    // 100100
    // 420100
    // RRZE-AI => 420103



namespace RRZE\Hub;

defined('ABSPATH') || exit;

use function RRZE\Hub\Config\logIt;


class Sync{
    protected $pluginFile;

    protected $UnivISURL;

    public function __construct($pluginFile) {
        $this->pluginFile = $pluginFile;
        $this->UnivISURL = (!empty($this->options['sync_univis_url']) ? $this->options['sync_univis_url'] : 'https://univis.uni-erlangen.de');
    }


    public function onLoaded() {
        // add_action('update_option_rrze-hub', [$this, 'doSync'], 10, 1 );
        add_filter( 'pre_update_option_rrze-hub',  [$this, 'doSync'], 10, 1 );
    }

    public function doSync($options) {
        if (!empty($options['sync_univisIDs'])){
            $aUnivisIDs = explode("\n", $options['sync_univisIDs']);
            foreach($aUnivisIDs as $sUnivisID){
                $sUnivisID = trim($sUnivisID);
                if (!empty($sUnivisID)){
                    $uID = $this->getUnivisID($sUnivisID);
                    if (!empty($uID)){
                        if (!empty($options['sync_dataType'])) {
                            if (in_array('persons', $options['sync_dataType'])) {
                                $aCnt = $this->syncPersons($sUnivisID, $uID);
                                logIt( $sUnivisID . ' : ' . $aCnt['sync'] . ' persons synchronized and ' . $aCnt['del']  . ' deleted.');
                            }
                            if (in_array('lectures', $options['sync_dataType'])) {
                                $aCnt = $this->syncLectures($sUnivisID, $uID);
                                logIt( $sUnivisID . ' : ' . $aCnt['sync'] . ' lectures synchronized and ' . $aCnt['del']  . ' deleted.');
                            }
                        }
                    }
                }
            }
        }
        return $options;
    }

    public function getUnivisID($sUnivisID){
        global $wpdb;

        // insert/update univis
        $prepare_vals = [
            $sUnivisID
        ];
        $wpdb->query($wpdb->prepare("CALL setUnivis(%s, @retID)", $prepare_vals));
        if ($wpdb->last_error){
            echo json_encode($wpdb->last_error);
            exit;
        }
        return $wpdb->get_var("SELECT @retID");
    }


    public function storePerson($uID, $person){
        global $wpdb;

        $prepare_vals = [
            $uID,
            empty($person['key'])?'':$person['key'],
            empty($person['person_id'])?'':$person['person_id'],
            empty($person['title'])?'':$person['title'],
            empty($person['atitle'])?'':$person['atitle'],
            empty($person['firstname'])?'':$person['firstname'],
            empty($person['lastname'])?'':$person['lastname'],
            empty($person['department'])?'':$person['department'],
            empty($person['organization'])?'':$person['organization'],
            empty($person['work'])?'':$person['work'],
            empty($person['orga_position'])?'':$person['orga_position'],
            empty($person['orga_position_order'])?0:$person['orga_position_order'],
            empty($person['title_long'])?'':$person['title_long']
        ];

        // insert/update persons
        $wpdb->query($wpdb->prepare("CALL setPerson(%d,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%d,%s, @retID)", $prepare_vals));
        if ($wpdb->last_error){
            echo json_encode($wpdb->last_error);
            exit;
        }

        return $wpdb->get_var("SELECT @retID");
    }


    public function syncPersons($sUnivisID, $uID) {
        global $wpdb;

        $aCnt = [
            'sync' => 0,
            'del' => 0
        ];

        $data = '';
        $univis = new UnivISAPI($this->UnivISURL, $sUnivisID, NULL);
        // $data = $univis->getData('personAll', NULL);
        $data = $univis->getData('personByOrga', NULL);

        // reverse elements order because of orga_position (1. "Leitung", ... N. "Mitarbeiter" referring to the same person => "Leitung" would be overwritten by "Mitarbeiter" in setPerson())
        $data = array_reverse($data);

        $aUsedIDs = [];

        foreach ($data as $position => $persons){
            foreach ($persons as $person){
                $personID = $this->storePerson($uID, $person);
                $aUsedIDs[] = $personID;

                if (!empty($person['locations'])){
                    foreach ($person['locations'] as $location){
                        $prepare_vals = [
                            empty($location['office'])?'':$location['office'],
                            empty($location['email'])?'':$location['email'],
                            empty($location['tel'])?'':$location['tel'],
                            empty($location['tel_call'])?'':$location['tel_call'],
                            empty($location['fax'])?'':$location['fax'],
                            empty($location['mobile'])?'':$location['mobile'],
                            empty($location['mobile_call'])?'':$location['mobile_call'],
                            empty($location['url'])?'':$location['url'],
                            empty($location['street'])?'':$location['street'],
                            empty($location['ort'])?'':$location['ort']
                        ];

                        // insert/update locations
                        $wpdb->query($wpdb->prepare("CALL setLocation(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s, @retID)", $prepare_vals));
                        if ($wpdb->last_error){
                            echo json_encode($wpdb->last_error);
                            exit;
                        }
                        $locationID = $wpdb->get_var("SELECT @retID");

                        // insert/update personLocation
                        $prepare_vals = [
                            $personID,
                            $locationID,
                        ];

                        $wpdb->query($wpdb->prepare("CALL setPersonLocation(%d,%d)", $prepare_vals));
                        if ($wpdb->last_error){
                            echo json_encode($wpdb->last_error);
                            exit;
                        }
                    }
                }

                if (!empty($person['officehours'])){
                    foreach ($person['officehours'] as $officehour){
                        $prepare_vals = [
                            empty($officehour['starttime'])?'':$officehour['starttime'],
                            empty($officehour['endtime'])?'':$officehour['endtime'],
                            empty($officehour['office'])?'':$officehour['office'],
                            empty($officehour['repeat'])?'':$officehour['repeat'],
                            empty($officehour['comment'])?'':$officehour['comment'],
                        ];

                        // insert/update officehours
                        $wpdb->query($wpdb->prepare("CALL setOfficehours(%s,%s,%s,%s,%s, @retID)", $prepare_vals));
                        if ($wpdb->last_error){
                            echo json_encode($wpdb->last_error);
                            exit;
                        }
                        $officehourID = $wpdb->get_var("SELECT @retID");

                        // insert/update personOfficehours
                        $prepare_vals = [
                            $personID,
                            $officehourID,
                        ];

                        $wpdb->query($wpdb->prepare("CALL setPersonOfficehours(%d,%d)", $prepare_vals));
                        if ($wpdb->last_error){
                            echo json_encode($wpdb->last_error);
                            exit;
                        }
                    }
                }
            }
        }  


        // delete unused persons
        $aUsedIDs = array_unique($aUsedIDs);

        $prepare_vals = [
            $uID,
            implode(',', $aUsedIDs)
        ];

        $aCnt['sync'] = count($aUsedIDs);

        $wpdb->query($wpdb->prepare("CALL deletePerson(%d,%s, @iDel)", $prepare_vals));
        if ($wpdb->last_error){
            echo json_encode($wpdb->last_error);
            exit;
        }
        $aCnt['del'] = $wpdb->get_var("SELECT @iDel");

        return $aCnt;
    }


    public function syncLectures($sUnivisID, $uID) {
        global $wpdb;

        $aCnt = [
            'sync' => 0,
            'del' => 0
        ];

        $data = '';
        $univis = new UnivISAPI($this->UnivISURL, $sUnivisID, NULL);
        $data = $univis->getData('lectureByDepartment');

        $aUsedIDs = [];

        foreach ($data as $typ => $veranstaltungen){
            foreach ($veranstaltungen as $aEntry){
                $lecID = 0;
                $lang = 'de';
                if (!empty($aEntry['leclanguage'])){
                    switch ($aEntry['leclanguage']){
                        case 'E' : $lang = 'en';
                        break;
                        case 'F' : $lang = 'fr';
                            break;
                        case 'S' : $lang = 'es';
                            break;
                        case 'R' : $lang = 'ru';
                            break;
                        case 'C' : $lang = 'zh';
                            break;
                    }
                }
                
                $prepare_vals = [
                    $uID,
                    $aEntry['name'],
                    empty($aEntry['ects_name'])?'':$aEntry['ects_name'],
                    $typ,
                    $aEntry['lecture_type'],
                    empty($aEntry['url_description'])?'':$aEntry['url_description'],
                    empty($aEntry['sws'])?0:(int) filter_var($aEntry['sws'], FILTER_SANITIZE_NUMBER_INT),
                    !empty($aEntry['beginners']),
                    !empty($aEntry['fruehstud']),
                    !empty($aEntry['gast']),
                    !empty($aEntry['evaluation']),
                    !empty($aEntry['ects']),
                    empty($aEntry['ects_cred'])?'':$aEntry['ects_cred'],
                    $lang,
                    empty($aEntry['summary'])?'':$aEntry['summary'],
                    empty($aEntry['key'])?'':$aEntry['key'],
                    empty($aEntry['lecture_id'])?'':$aEntry['lecture_id']
                ];

                // insert/update lectures
                $wpdb->query($wpdb->prepare("CALL storeLecture(%d,%s,%s,%s,%s,%s,%d,%d,%d,%d,%d,%d,%s,%s,%s,%s,%s, @retID)", $prepare_vals));

                if ($wpdb->last_error){
                    echo json_encode($wpdb->last_error);
                    exit;
                }

                $lectureID = $wpdb->get_var("SELECT @retID");
                $aCnt['sync']++;


                if (empty($lectureID)){
                    echo 'empty!' . $aEntry['name'] . ' ' . $aEntry['key'];
                    exit;
                }

                $aUsedIDs[] = $lectureID;

                if (!empty($aEntry['lecturers'])){
                    foreach($aEntry['lecturers'] as $person){
                        $personID = $this->storePerson($uID, $person);
    
                        // insert/update personLecture
                        $prepare_vals = [
                            $lectureID,
                            $personID
                        ];
    
                        $wpdb->query($wpdb->prepare("CALL setPersonLecture(%d,%d)", $prepare_vals));
                        if ($wpdb->last_error){
                            echo json_encode($wpdb->last_error);
                            exit;
                        }
                    }
                }

                if (!empty($lectureID) && !empty($aEntry['courses'])){
                    foreach($aEntry['courses'] as $course){
                        foreach ($course['term'] as $term){
                            $prepare_vals = [
                                empty($term['room']['key'])?'':$term['room']['key'],
                                empty($term['room']['name'])?'':$term['room']['name'],
                                empty($term['room']['short'])?'':$term['room']['short'],
                                empty($term['room']['roomno'])?'':$term['room']['roomno'],
                                empty($term['room']['buildno'])?'':$term['room']['buildno'],
                                empty($term['room']['address'])?'':$term['room']['address'],
                                empty($term['room']['description'])?'':$term['room']['description'],
                                empty($term['room']['north'])?'':$term['room']['north'],
                                empty($term['room']['east'])?'':$term['room']['east']
                            ];
                            // insert/update room
                            $wpdb->query($wpdb->prepare("CALL setRoom(%s,%s,%s,%s,%s,%s,%s,%s,%s, @retID)", $prepare_vals));
                            if ($wpdb->last_error){
                                echo json_encode($wpdb->last_error);
                                exit;
                            }
                            $roomID = $wpdb->get_var("SELECT @retID");

                            $prepare_vals = [
                                $lectureID,
                                $roomID,
                                empty($term['repeat'])?'':trim($term['repeat']),
                                empty($term['exclude'])?'':$term['exclude'],
                                empty($term['starttime'])?'':$term['starttime'],
                                empty($term['endtime'])?'':$term['endtime']
                            ];
                            // insert/update courses
                            $wpdb->query($wpdb->prepare("CALL setCourse(%d,%d,%s,%s,%s,%s)", $prepare_vals));

                            if ($wpdb->last_error){
                                echo json_encode($wpdb->last_error);
                                exit;
                            }
                        }
                    }
                }

            }
        }

        // delete unused lectures
        $prepare_vals = [
            $uID,
            implode(',', $aUsedIDs)
        ];

        $wpdb->query($wpdb->prepare("CALL deleteLecture(%d,%s, @iDel)", $prepare_vals));
        if ($wpdb->last_error){
            echo json_encode($wpdb->last_error);
            exit;
        }
        $aCnt['del'] = $wpdb->get_var("SELECT @iDel");

        return $aCnt;
    }
}
