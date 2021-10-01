<?php

namespace RRZE\Hub;

defined('ABSPATH') || exit;


class Schema {

    protected $organization;
    protected $address;
    protected $person;

    public function __construct() {
        $this->organization = [
            // '@context' => 'https://schema.org/CollegeOrUniversity',
            '@type' => 'CollegeOrUniversity',
            'name' => 'organization',
            'sameAs' => [],
            'department' => [
                '@type' => 'Organization',
                'name' => 'department', // schema-fieldname => data-fieldname
            ],
        ];
    
        $this->address = [
            // '@context' => 'https://schema.org/address',
            '@type' => 'PostalAddress',
            'addressLocality' => '',
            'addressCountry' => '',
            'postalCode' => '',
            'streetAddress' => '',
        ];
    
        $this->person = [
            // '@context' => 'https://schema.org/', // not https://schema.org/person !
            '@type' => 'Person',
            'name' => '', // firstname blank lastname
            'jobTitle' => 'title_long',
            'worksFor' => $this->organization,
            'address' => $this->address,
            'email' => '',
            'telephone' => '',
            'url' => '',
        ];
    }


    // in_array does not support multidimensional arrays, let's fix it
    // and we've got to look for both keys and keys of values if value is an array
    static function in_array_multi($needle, $haystack) {
        foreach ($haystack as $key => $values) {
            if (($key == $needle) || (is_array($values) && self::in_array_multi($needle, $values))) {
                return true;
            }
        }
    
        return false;
    }

    public function getSchema($sType, $aIn) {
        global $wpdb;
        $aRet = ['@context' => 'https://schema.org/'];

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
            foreach ($aEntry as $keyIn => $valIn) {

                // this would work if schema's keys were unique but the are not (f.e. name in Person and name in Department and name in Organization)
                // if (self::in_array_multi($field, $aSchema)) {
                //     $aRet[$field] = $value;
                // }

                // 2DO: who to make locations fit? does Schema provide more than one email,phone,fax for Person?

                // this works perfectly:
                foreach($aSchema as $keySchema => $valSchema){
                    if (is_array($valSchema)){
                        foreach ($valSchema as $keySchemaSub => $valSchemaSub){
                            if ($keyIn == $keySchemaSub){
                                $aRet[$keySchema][$keySchemaSub] = $valIn;
                            }elseif ($keyIn == $valSchemaSub){
                                $aRet[$keySchema][$keySchemaSub] = $valIn;
                            }
                        }
                    }else{
                        if ($keyIn == $valSchema){
                            $aRet[$keySchema] = $valIn;
                        }
                    }
                }
            }
        }

        return json_encode($aRet);
    }
}