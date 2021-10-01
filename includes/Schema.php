<?php

namespace RRZE\Hub;

defined('ABSPATH') || exit;


class Schema {

    protected $organization;
    protected $address;
    protected $person;

    public function __construct() {
        $this->organization = [
            '@type' => 'Organization',
            'name' => '',
            'sameAs' => [],
        ];
    
        $this->address = [
            '@type' => 'PostalAddress',
            'addressLocality' => '',
            'addressCountry' => '',
        ];
    
        $this->person = [
            '@type' => 'Person',
            'name' => '',
            'firstname' => '', // nur Test - ist ein ungültiges Element für das Schema
            'jobTitle' => '',
            'worksFor ' => $this->organization,
            'url' => '',
            'address' => $this->address,
        ];
    }


    // in_array does not support multidimensional arrays, let's fix it
    static function in_array_multi($needle, $haystack) {
        foreach ($haystack as $item) {
            if (($item == $needle) || (is_array($item) && self::in_array_multi($needle, $item))) {
                return true;
            }
        }
    
        return false;
    }

    public function getSchema($sType, $aIn) {
        global $wpdb;
        $aRet = [];

        // Testdata:
        $aIn = [
            '123' =>
            [
              "person_id" => "123456",
              "title" => "Dr.",
              "title_long" => "Doktor",
              "atitle" => "",
              "firstname"  => "Fred",
              "lastname" => "Astaire",
              "organization"  => "Department der Albernheit",
              "department"  => "Lehrstuhl für Digitalen Tanz",
              "letter"  => "G",
              "locations" => [
                  '670' =>[
                  "email" => "fred.astaire@unknownwebsite.tld",
                  "tel" => "+49 9131 85-123456789",
                  "tel_call" => "+49913185123456789",
                  "mobile" => "",
                  "mobile_call" => "",
                  "fax" => "+49 9131 85-987654",
                  "street" => "Road to nowhere 11",
                  "city" => "91058 Erlangen",
                  "office" => "01.222-999",
                  ],
                ],
              "officehours" => [
                    '24'=> [                  
                        "repeat" => "Di",
                        "starttime" => "14:00",
                        "endtime" => "16:00",
                        "office" => "01.116-128",
                        "comment" => "Bring cookies",
                    ]
                  ]
            ]];

        if (property_exists("\\RRZE\Hub\\Schema", $sType) === FALSE){
            return json_encode(['Error' => "Unknown schema for type '$sType'"]);
        }

        $aSchema = $this->$sType;
        $aRet = ['@type' => $aSchema['@type']];

        foreach ($aIn as $ID => $aEntry) {
            foreach ($aEntry as $field => $value) {
                if (self::in_array_multi($field, array_keys($aSchema))) {
                    $aRet[$field] = $value;
                }
            }
        }

        return json_encode($aRet);
    }
}