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
            echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
            exit;
        }
        return $wpdb->get_var("SELECT @retID");
    }


    public function storePerson($person){
        global $wpdb;

        $prepare_vals = [
            empty($person['key'])?'':$person['key'],
            empty($person['person_id'])?'':$person['person_id'],
            empty($person['title'])?'':$person['title'],
            empty($person['title_long'])?'':$person['title_long'],
            empty($person['atitle'])?'':$person['atitle'],
            empty($person['firstname'])?'':$person['firstname'],
            empty($person['lastname'])?'':$person['lastname']
        ];

        // insert/update persons
        $wpdb->query($wpdb->prepare("CALL setPerson(%s,%s,%s,%s,%s,%s,%s, @retID)", $prepare_vals));
        if ($wpdb->last_error){
            echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
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
        $data = $univis->getData('personAll', NULL);

        // echo '<pre>';
        // var_dump($data);
        // exit;

        $aUsedIDs = [];

        foreach ($data as $person){
            $personID = $this->storePerson($person);

            $aUsedIDs[] = $personID;

            $prepare_vals = [
                $sUnivisID,
                empty($person['organization'])?'':$person['organization']
            ];

            // insert/update organization
            $wpdb->query($wpdb->prepare("CALL setOrganization(%s,%s, @retID)", $prepare_vals));
            if ($wpdb->last_error){
                echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
                exit;
            }
            $organizationID = $wpdb->get_var("SELECT @retID");

            $prepare_vals = [
                $sUnivisID,
                $organizationID,
                empty($person['department'])?'':$person['department']
            ];

            // insert/update department
            $wpdb->query($wpdb->prepare("CALL setDepartment(%s,%d,%s, @retID)", $prepare_vals));
            if ($wpdb->last_error){
                echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
                exit;
            }
            $departmentID = $wpdb->get_var("SELECT @retID");

            $prepare_vals = [
                $personID,
                $departmentID,
                empty($person['work'])?'':$person['work']
            ];

            // insert/update personDepartment
            $wpdb->query($wpdb->prepare("CALL setPersonDepartment(%d,%d,%s)", $prepare_vals));
            if ($wpdb->last_error){
                echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
                exit;
            }

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
                        echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
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
                        echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
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
                        echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
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
                        echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
                        exit;
                    }
                }
            }

            if (!empty($person['positions'])){
                foreach ($person['positions'] as $position){
                    $prepare_vals = [
                        empty($position['name'])?'':$position['name'],
                    ];

                    // insert/update position
                    $wpdb->query($wpdb->prepare("CALL setPosition(%s, @retID)", $prepare_vals));
                    if ($wpdb->last_error){
                        echo 'setPosition ' . json_encode($wpdb->last_error);
                        exit;
                    }
                    $positionID = $wpdb->get_var("SELECT @retID");

                    if ($wpdb->last_error){
                        echo 'get_var position ' . json_encode($wpdb->last_error);
                        exit;
                    }

                    // insert/update personPosition
                    $prepare_vals = [
                        $personID,
                        $positionID,
                        empty($position['order'])?0:$position['order']
                    ];

                    $wpdb->query($wpdb->prepare("CALL setPersonPosition(%d,%d,%d)", $prepare_vals));
                    if ($wpdb->last_error){
                        echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
                        exit;
                    }
                }
            }
        }

        // delete unused persons
        $aUsedIDs = array_unique($aUsedIDs);

        $prepare_vals = [
            $departmentID,
            implode(',', $aUsedIDs)
        ];

        $aCnt['sync'] = count($aUsedIDs);

        $wpdb->query($wpdb->prepare("CALL deletePerson(%d,%s, @iDel)", $prepare_vals));
        if ($wpdb->last_error){
            echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
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

        // echo '<pre>';
        // var_dump($data);
        // exit;

        $aUsedIDs = [];

        foreach ($data as $aLecture){
            $aLang = ['short' => 'de', 'long' => 'German'];
            if (!empty($aLecture['leclanguage'])){
                switch ($aLecture['leclanguage']){
                    case 'E' : $aLang = ['short' => 'en', 'long' => 'English'];
                        break;
                    case 'F' : $aLang = ['short' => 'fr', 'long' => 'French'];
                        break;
                    case 'S' : $aLang = ['short' => 'es', 'long' => 'Spanish'];
                        break;
                    case 'R' : $aLang = ['short' => 'ru', 'long' => 'Russian'];
                        break;
                    case 'C' : $aLang = ['short' => 'zh', 'long' => 'Chinese'];
                        break;
                }
            }

            $prepare_vals = [
                $aLang['short'],
                $aLang['long']
            ];

            // insert/update lecturetype
            $wpdb->query($wpdb->prepare("CALL setLanguage(%s,%s, @retID)", $prepare_vals));

            if ($wpdb->last_error){
                echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
                exit;
            }

            $languageID = $wpdb->get_var("SELECT @retID");

            $prepare_vals = [
                $aLecture['lecture_type'],
                $aLecture['lecture_type_short']
            ];

            // insert/update lecturetype
            $wpdb->query($wpdb->prepare("CALL setLecturetype(%s,%s, @retID)", $prepare_vals));

            if ($wpdb->last_error){
                echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
                exit;
            }

            $lecturetypeID = $wpdb->get_var("SELECT @retID");

            $prepare_vals = [
                $uID,
                $lecturetypeID,
                $languageID,
                $aLecture['name'],
                empty($aLecture['ects_name'])?'':$aLecture['ects_name'],
                empty($aLecture['url_description'])?'':$aLecture['url_description'],
                empty($aLecture['startdate'])?'':$aLecture['startdate'],
                empty($aLecture['enddate'])?'':$aLecture['enddate'],
                empty($aLecture['starttime'])?'':$aLecture['starttime'],
                empty($aLecture['endtime'])?'':$aLecture['endtime'],
                empty($aLecture['comment'])?'':$aLecture['comment'],
                empty($aLecture['organizational'])?'':$aLecture['organizational'],
                empty($aLecture['maxturnout'])?0:(int) filter_var($aLecture['maxturnout'], FILTER_SANITIZE_NUMBER_INT),
                empty($aLecture['sws'])?0:(int) filter_var($aLecture['sws'], FILTER_SANITIZE_NUMBER_INT),
                !empty($aLecture['beginners']),
                !empty($aLecture['earlystudy']),
                !empty($aLecture['guest']),
                !empty($aLecture['evaluation']),
                !empty($aLecture['certification']),
                !empty($aLecture['ects']),
                empty($aLecture['ects_cred'])?'':$aLecture['ects_cred'],
                empty($aLecture['ects_literature'])?'':$aLecture['ects_literature'],
                empty($aLecture['ects_summary'])?'':$aLecture['ects_summary'],
                empty($aLecture['ects_organizational'])?'':$aLecture['ects_organizational'],
                empty($aLecture['keywords'])?'':$aLecture['keywords'],
                empty($aLecture['literature'])?'':$aLecture['literature'],
                empty($aLecture['summary'])?'':$aLecture['summary'],
                empty($aLecture['key'])?'':$aLecture['key'],
                empty($aLecture['lecture_id'])?'':$aLecture['lecture_id']
            ];

            // insert/update lectures
            $wpdb->query($wpdb->prepare("CALL setLecture(%d,%d,%d,%s,%s,%s,%s,%s,%s,%s,%s,%s,%d,%d,%d,%d,%d,%d,%d,%d,%s,%s,%s,%s,%s,%s,%s,%s,%s, @retID)", $prepare_vals));

            if ($wpdb->last_error){
                echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
                exit;
            }

            $lectureID = $wpdb->get_var("SELECT @retID");
            $aCnt['sync']++;

            $aUsedIDs[] = $lectureID;

            if (!empty($aLecture['lecturers'])){
                foreach($aLecture['lecturers'] as $person){
                    $personID = $this->storePerson($person);

                    // insert/update personLecture
                    $prepare_vals = [
                        $lectureID,
                        $personID
                    ];

                    $wpdb->query($wpdb->prepare("CALL setPersonLecture(%d,%d)", $prepare_vals));
                    if ($wpdb->last_error){
                        echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
                        exit;
                    }
                }
            }

            if (!empty($aLecture['stud'])) {
                foreach ($aLecture['stud'] as $stud){
                    // insert/update stud
                    $prepare_vals = [
                        $lectureID,
                        empty($stud['richt'])?'':$stud['richt'],
                        empty($stud['pflicht'])?'':$stud['pflicht'],
                        empty($stud['sem'])?0:(int) filter_var($stud['sem'], FILTER_SANITIZE_NUMBER_INT),
                        empty($stud['credits'])?'':$stud['credits']
                    ];

                    $wpdb->query($wpdb->prepare("CALL setStud(%d,%s,%s,%d,%s)", $prepare_vals));
                    if ($wpdb->last_error){
                        echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
                        exit;
                    }

                }
            }

            if (!empty($lectureID) && !empty($aLecture['courses'])){
                foreach($aLecture['courses'] as $course){
                    $prepare_vals = [
                        $lectureID,
                        empty($course['course_id'])?'':$course['course_id'],
                        empty($course['coursename'])?'':$course['coursename'],
                        empty($course['time_description'])?'':$course['time_description']
                    ];
        
                    // insert/update course
                    $wpdb->query($wpdb->prepare("CALL setCourse(%d,%s,%s,%s, @retID)", $prepare_vals));
        
                    if ($wpdb->last_error){
                        echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
                        exit;
                    }
        
                    $courseID = $wpdb->get_var("SELECT @retID");

                    if (!empty($course['lecturers'])){
                        foreach($course['lecturers'] as $person){
                            $personID = $this->storePerson($person);
        
                            // insert/update personCourse
                            $prepare_vals = [
                                $personID,
                                $courseID
                            ];
        
                            $wpdb->query($wpdb->prepare("CALL setPersonCourse(%d,%d)", $prepare_vals));
                            if ($wpdb->last_error){
                                echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
                                exit;
                            }
                        }
                    }

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
                            echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
                            exit;
                        }
                        $roomID = $wpdb->get_var("SELECT @retID");

                        $prepare_vals = [
                            $courseID,
                            $roomID,
                            empty($term['repeat'])?'':trim($term['repeat']),
                            empty($term['exclude'])?'':$term['exclude'],
                            empty($term['startdate'])?'':$term['startdate'],
                            empty($term['enddate'])?'':$term['enddate'],
                            empty($term['starttime'])?'':$term['starttime'],
                            empty($term['endtime'])?'':$term['endtime']
                        ];
                        // insert/update terms
                        $wpdb->query($wpdb->prepare("CALL setTerm(%d,%d,%s,%s,%s,%s,%s,%s)", $prepare_vals));

                        if ($wpdb->last_error){
                            echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
                            exit;
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
            echo '$wpdb->last_query' . json_encode($wpdb->last_query) . '| $wpdb->last_error= ' . json_encode($wpdb->last_error);
            exit;
        }
        $aCnt['del'] = $wpdb->get_var("SELECT @iDel");

        return $aCnt;
    }
}
