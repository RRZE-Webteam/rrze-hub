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
            'addressLocality' => 'city',
            'addressCountry' => 'country',
            'postalCode' => 'postalcode',
            'streetAddress' => 'street',
        ];

        $this->person = [
            // '@context' => 'https://schema.org/', // not https://schema.org/person !
            '@type' => 'Person',
            'name' => 'schema_name',
            'honorificPrefix' => 'title',
            'honorificSuffix' => 'atitle',
            'givenName' => 'firstname',
            'familyName' => 'lastname',
            'jobTitle' => 'work',
            'worksFor' => $this->organization,
            'address' => $this->address,
            'email' => 'email',
            'telephone' => 'tel',
            'url' => 'url',
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
        $aRet = ['@context' => 'https://schema.org/'];

        if (property_exists("\\RRZE\Hub\\Schema", $sType) === FALSE){
            return json_encode(['Error' => "Unknown schema for type '$sType'"]);
        }

        $aSchema = $this->$sType;
        $aRet = [
            '@context' => 'https://schema.org/',
            '@type' => $aSchema['@type']
        ];

        foreach ($aIn as $keyIn => $valIn) {
            // this would work if schema's keys were unique but the are not (f.e. name in Person and name in Department and name in Organization)
            // if (self::in_array_multi($field, $aSchema)) {
            //     $aRet[$field] = $value;
            // }

            // this works perfectly (https://validator.schema.org/ verified as VALID, 0 bugs, 0 warnings \o/ :
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

        return '<script type="application/ld+json">' . json_encode($aRet) . '</script>';
    }
}