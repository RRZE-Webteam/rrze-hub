<?php

namespace RRZE\Hub;

defined('ABSPATH') || exit;


class Schema
{
    protected $organization;
    protected $address;
    protected $person;

    public function __construct()
    {
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
    public static function inArrayMulti($needle, $haystack)
    {
        foreach ($haystack as $key => $values) {
            if (($key == $needle) || (is_array($values) && self::inArrayMulti($needle, $values))) {
                return true;
            }
        }
    
        return false;
    }

    public static function flattenAssocArray(array $aIn)
    {
        $aRet = array();
        array_walk_recursive($aIn, function ($a, $b) use (&$aRet) {
            $aRet[$b] = $a;
        });
        return $aRet;
    }


    public function getSchema($sType, $aIn)
    {
        $aRet = ['@context' => 'https://schema.org/'];

        if (property_exists("\\RRZE\Hub\\Schema", $sType) === false) {
            return json_encode(['Error' => "Unknown schema for type '$sType'"]);
        }

        $aSchema = $this->$sType;
        $aRet = [
            '@context' => 'https://schema.org/',
            '@type' => $aSchema['@type']
        ];

        // 2DO: email, telephone can be >1 in https://validator.schema.org/ ! 
        foreach ($aIn as $keyIn => $valIn) {
            foreach ($aSchema as $keySchema => $valSchema) {
                if (is_array($valSchema)) {
                    foreach ($valSchema as $keySchemaSub => $valSchemaSub) {
                        if ($keyIn == $keySchemaSub) {
                            $aRet[$keySchema][$keySchemaSub] = $valIn;
                        } elseif ($keyIn == $valSchemaSub) {
                            $aRet[$keySchema][$keySchemaSub] = $valIn;
                        }
                    }
                } else {
                    if ($keyIn == $valSchema) {
                        $aRet[$keySchema] = $valIn;
                    }
                }
            }
        }

        return '<script type="application/ld+json">' . json_encode($aRet) . '</script>';
    }
}