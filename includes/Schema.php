<?php

namespace RRZE\Hub;

defined('ABSPATH') || exit;


/*

UnivIS ID : 40014582


Person with all data according to schema.org: 
<script type="application/ld+json">
{
    "@context":"https://schema.org/",
    "@type":"Person",
    "name":"Dipl.-Inf. Wolfgang Wiese, Akad. ORat",
    "honorificPrefix":"Dipl.-Inf.",
    "honorificSuffix":"Akad. ORat",
    "givenName":"Wolfgang",
    "familyName":"Wiese",
    "telephone": [
        "+49 9131 85-28326",
        "+49 9131 85-28135"
    ],
    "email":[
        "wolfgang.wiese@fau.de",
        "test+wolfgang.wiese@fau.de"
    ],
    "faxNumber":[
        "+49 9131 302941"
    ],
    "worksFor":
        {
            "@type":"CollegeOrUniversity",
            "name":"Friedrich-Alexander-Universit&auml;t (FAU)",
            "department":{
	            "@type":"Organization",
                "name":"Regionales Rechenzentrum Erlangen (RRZE)",
		        "member":{
                    "@type":"OrganizationRole",
                    "namedPosition":[
                        "Webmaster", 
                        "UnivIS-Beauftragte"
                    ]
                },
                "department":{
	                "@type":"Organization",
	                "name":"Abteilung Ausbildung &amp; Information (RRZE)",
		            "member":{
                        "@type": "OrganizationRole",
                    	"namedPosition":[
                            "Leitung", 
                            "Webmaster", 
                            "UnivIS-Beauftragte"
                        ]
                    }
                },
                "ContactPoint":
                    {
                    "hoursAvailable":{
                    	"@type":"OpeningHoursSpecification",
                        "name":[
                        	"Mi 9:30 - 10:30, Raum 1.018, Testeintrag, nicht kommen :)",
                        	"jeden Monat am 1. Do 15:00 - 16:00, Raum VC, Webmaster-Sprechstunde"
                        	]
                       }
                    },
                "location": {
                    "@type": "Place",
                    "address":
                        {
                        "@type":"PostalAddress",
                        "addressLocality":"Erlangen, Deutschland",
                        "postalCode":"91058",
                        "streetAddress":"Martensstraße 1"         
                        },
                    "name": "Raum 1.024"
                    },
                "url":"https://www.rrze.fau.de/"
                }
            },
            "url":"https://www.fau.de/"
        }
    }
</script>

*/

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
            // '@context' => 'https://schema.org/Person',
            '@type' => 'Person',
            'name' => 'schema_name',
            'honorificPrefix' => 'title',
            'honorificSuffix' => 'atitle',
            'givenName' => 'firstname',
            'familyName' => 'lastname',
            'jobTitle' => 'work',
            'worksFor' => $this->organization,
            'address' => $this->address,
            // 'email' => 'email',
            'email' => ['email'],
            'telephone' => 'tel',
            'url' => 'url',
        ];
    }


    // in_array does not support multidimensional arrays, let's fix it
    // and we've got to look for both keys and keys of values if value is an array
    public static function inArrayMulti(string $needle, array $haystack): bool
    {
        foreach ($haystack as $key => $values) {
            if (($key == $needle) || (is_array($values) && self::inArrayMulti($needle, $values))) {
                return true;
            }
        }
    
        return false;
    }

    public function in_array_r($item , $array){

        echo json_encode($array);
        exit;

        $ret = preg_match_all('/"'.preg_quote($item, '/').'"/i' , json_encode($array), $matches);
        if ($ret){
            echo '<pre>';
            var_dump($matches);
            exit;
        }
    }

    public static function flattenAssocArray(array $aIn): array 
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

        // => einfach als [] array ausgeben; z.B. "email":["email1@domain.tld", "email2@domain.tld"]

        foreach ($aIn as $k => $v) {
            foreach ($v as $keyIn => $valIn) {
                foreach ($aSchema as $keySchema => $valSchema) {
                    if (is_array($valSchema)) {
                        foreach ($valSchema as $keySchemaSub => $valSchemaSub) {
                            
                            // BK 2021-12-13 START
                            if ($keySchemaSub == '@type'){
                                $aRet[$keySchema][$keySchemaSub] = $valSchemaSub;
                            }
                            // BK 2021-12-13 END

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
        }

        // $aRet = json_encode($aRet);

        // nur testweise auskommentiert
        // return '<script type="application/ld+json">' . json_encode($aRet) . '</script>';
        return $aRet;
    }
}