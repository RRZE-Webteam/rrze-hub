<?php

namespace RRZE\Hub\Config;

defined('ABSPATH') || exit;

/**
 * Gibt der Name der Option zurück.
 * @return array [description]
 */
function getOptionName()
{
    return 'rrze-hub';
}

/**
 * Gibt die Einstellungen des Menus zurück.
 * @return array [description]
 */
function getMenuSettings()
{
    return [
        'page_title'    => __('RRZE Hub', 'rrze-hub'),
        'menu_title'    => __('RRZE Hub', 'rrze-hub'),
        'capability'    => 'manage_options',
        'menu_slug'     => 'rrze-hub',
        'title'         => __('RRZE Hub Settings', 'rrze-hub'),
    ];
}

/**
 * Gibt die Einstellungen der Inhaltshilfe zurück.
 * @return array [description]
 */
function getHelpTab()
{
    return [
        [
            'id'        => 'rrze-hub-help',
            'content'   => [
                '<p>' . __('Here comes the Context Help content.', 'rrze-hub') . '</p>'
            ],
            'title'     => __('Overview', 'rrze-hub'),
            'sidebar'   => sprintf('<p><strong>%1$s:</strong></p><p><a href="https://blogs.fau.de/webworking">RRZE Webworking</a></p><p><a href="https://github.com/RRZE Webteam">%2$s</a></p>', __('For more information', 'rrze-hub'), __('RRZE Webteam on Github', 'rrze-hub'))
        ]
    ];
}

/**
 * Gibt die Einstellungen der Optionsbereiche zurück.
 * @return array [description]
 */
function getSections()
{
    return [
        [
            'id'    => 'sync',
            'title' => __('Synchronization', 'rrze-hub')
        ],
    ];
}

/**
 * Gibt die Einstellungen der Optionsfelder zurück.
 * @return array [description]
 */
function getFields()
{
    return [
        'sync' => [
            // [
            //     'name'              => 'univis_url',
            //     'label'             => __('Link zu <b><i>Univ</i>IS</b>', 'rrze-univis'),
            //     'desc'              => __('', 'rrze-univis'),
            //     'placeholder'       => __('', 'rrze-univis'),
            //     'type'              => 'text',
            //     'default'           => 'https://univis.uni-erlangen.de',
            //     'sanitize_callback' => 'esc_url_raw'
            // ],
            [
                'name'        => 'univisIDs',
                'label'       => __('Univis IDs', 'rrze-hub'),
                'desc'    => __('Enter IDs each line', 'rrze-hub'),
                'placeholder' => '',
                'type'        => 'textarea'
            ],
            [
                'name'    => 'dataType',
                'label'   => __('Sync these datatypes', 'rrze-hub'),
                'desc'    => '',
                'type'    => 'multicheck',
                'default' => [
                    'lehrveranstaltungen' => __('Lehrveranstaltungen', 'rrze-hub'),
                    'two' => 'two'
                ],
                'options'   => [
                    'jobs'   => __('Jobs', 'rrze-hub'),
                    'lectures'   => __('Lehrveranstaltungen', 'rrze-hub'),
                    'persons'   => __('Mitarbeiter', 'rrze-hub'),
                    'publications'   => __('Publikationen', 'rrze-hub'),
                    'rooms'   => __('Räume', 'rrze-hub'),
                ]
            ],
        ],
    ];
}


/**
 * Gibt die Einstellungen der Parameter für Shortcode für den klassischen Editor und für Gutenberg zurück.
 * @return array [description]
 */

function getShortcodeSettings(){
	return [
		'block' => [
            'blocktype' => 'rrze-hub/SHORTCODE-NAME', // dieser Wert muss angepasst werden
			'blockname' => 'SHORTCODE-NAME', // dieser Wert muss angepasst werden
			'title' => 'SHORTCODE-TITEL', // Der Titel, der in der Blockauswahl im Gutenberg Editor angezeigt wird
			'category' => 'widgets', // Die Kategorie, in der der Block im Gutenberg Editor angezeigt wird
            'icon' => 'admin-users',  // Das Icon des Blocks
            'tinymce_icon' => 'user', // Das Icon im TinyMCE Editor 
		],
		'Beispiel-Textfeld-Text' => [
			'default' => 'ein Beispiel-Wert',
			'field_type' => 'text', // Art des Feldes im Gutenberg Editor
			'label' => __( 'Beschriftung', 'rrze-hub' ),
			'type' => 'string' // Variablentyp der Eingabe
		],
		'Beispiel-Textfeld-Number' => [
			'default' => 0,
			'field_type' => 'text', // Art des Feldes im Gutenberg Editor
			'label' => __( 'Beschriftung', 'rrze-hub' ),
			'type' => 'number' // Variablentyp der Eingabe
		],
		'Beispiel-Textarea-String' => [
			'default' => 'ein Beispiel-Wert',
			'field_type' => 'textarea',
			'label' => __( 'Beschriftung', 'rrze-hub' ),
			'type' => 'string',
			'rows' => 5 // Anzahl der Zeilen 
		],
		'Beispiel-Radiobutton' => [
			'values' => [
				'wert1' => __( 'Wert 1', 'rrze-hub' ), // wert1 mit Beschriftung
				'wert2' => __( 'Wert 2', 'rrze-hub' )
			],
			'default' => 'DESC', // vorausgewählter Wert
			'field_type' => 'radio',
			'label' => __( 'Order', 'rrze-hub' ), // Beschriftung der Radiobutton-Gruppe
			'type' => 'string' // Variablentyp des auswählbaren Werts
		],
		'Beispiel-Checkbox' => [
			'field_type' => 'checkbox',
			'label' => __( 'Beschriftung', 'rrze-hub' ),
			'type' => 'boolean',
			'default'   => true // Vorauswahl: Haken gesetzt
        ],
        'Beispiel-Toggle' => [
            'field_type' => 'toggle',
            'label' => __( 'Beschriftung', 'rrze-hub' ),
            'type' => 'boolean',
            'default'   => true // Vorauswahl: ausgewählt
        ],
		'Beispiel-Select' => [
			'values' => [
                [
                    'id' => 'wert1',
                    'val' =>  __( 'Wert 1', 'rrze-hub' )
                ],
                [
                    'id' => 'wert2',
                    'val' =>  __( 'Wert 2', 'rrze-hub' )
                ],
			],
			'default' => 'wert1', // vorausgewählter Wert: Achtung: string, kein array!
			'field_type' => 'select',
			'label' => __( 'Beschriftung', 'rrze-hub' ),
			'type' => 'string' // Variablentyp des auswählbaren Werts
		],
        'Beispiel-Multi-Select' => [
			'values' => [
                [
                    'id' => 'wert1',
                    'val' =>  __( 'Wert 1', 'rrze-hub' )
                ],
                [
                    'id' => 'wert2',
                    'val' =>  __( 'Wert 2', 'rrze-hub' )
                ],
                [
                    'id' => 'wert3',
                    'val' =>  __( 'Wert 3', 'rrze-hub' )
                ],
			],
			'default' => ['wert1','wert3'], // vorausgewählte(r) Wert(e): Achtung: array, kein string!
			'field_type' => 'multi_select',
			'label' => __( 'Beschrifung', 'rrze-hub' ),
			'type' => 'array',
			'items'   => [
				'type' => 'string' // Variablentyp der auswählbaren Werte
			]
        ]
    ];
}

