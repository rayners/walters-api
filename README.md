# WaltersApi

The Walters Art Museum in Baltimore, Maryland is internationally renowned for its collection of art. This is an API to access information about the art collection there.

## Installation

Add this line to your application's Gemfile:

    gem 'walters_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install walters_api

## Usage

### Places
/places

Ex:
  
    {
    "places": [
        {
            "id": "afghanistan",
            "name": "Afghanistan",
            "thumbnails": [
                {
                    "url": "http://art.thewalters.org/images/art/thumbnails/s_cps_w652162a_fp_dd.jpg"
                },
                {
                    "url": "http://art.thewalters.org/images/art/thumbnails/s_cps_w602472b_fp_dd.jpg"
                },
                {
                    "url": "http://art.thewalters.org/images/art/thumbnails/s_cps_w602493a_fp_dd.jpg"
                }
            ]
        }
    ]
    }
/places/${PLACE}

Ex: /places/Afghanistan

    {
    "pieces": [
        {
            "id": "7066",
            "id_string": "book-of-kings-shahnama",
            "title": "Book of Kings (Shahnama)",
            "period": "1028 AH/AD 1618-1619 (Qajar)",
            "accession": "W.602",
            "thumbnail": {
                "url": "http://art.thewalters.org/images/art/thumbnails/cps_w602binding_topext_dd.jpg",
                "width": "235",
                "height": "338"
            }
        }
    ]
    }

### Mediums
/mediums

Ex:

   [
       {
           "id": "arms--armor",
           "name": "Arms & Armor",
           "thumbnail": {
               "url": "http://art.thewalters.org/images/medium/med_arm_51581.jpg"
           }
       }
  ]
/mediums/${MEDIUM}

Ex: /mediums/wood

    {
    "pieces": [
        {
            "id": "25138",
            "id_string": "cassone",
            "title": "\"Cassone\"",
            "period": "16th century",
            "accession": "65.35",
            "thumbnail": {
                "url": "http://art.thewalters.org/images/art/thumbnails/pl9_6535_fnt_bw.jpg",
                "width": "235",
                "height": "116"
            }
        },
        {
            "id": "29687",
            "id_string": "cassone",
            "title": "\"Cassone\"",
            "period": "ca. 1500",
            "accession": "65.34",
            "thumbnail": {
                "url": "http://art.thewalters.org/images/art/thumbnails/pl9_6534_fnt_bw.jpg",
                "width": "235",
                "height": "126"
            }
        }
    ]
    }

### Creators
/creators
/creators/${CREATOR}

### Tags
/tags

Ex: 

    [
        {
            "id": "abduction",
            "count": "2"
        },
        {
            "id": "abolitionist",
            "count": ""
        }
    ]
/tags/${TAG}

Ex: /tags/abduction

    {
        "pieces": [
            {
                "id": "34500",
                "id_string": "christ-and-the-woman-taken-in-adultery",
                "title": "Christ and the Woman Taken in Adultery",
                "period": "1841",
                "accession": "37.1825",
                "tags": [
                    "religious",
                    "abduction",
                    "rapw",
                    "rape",
                    "christ"
                ],
                "thumbnail": {
                    "url": "http://art.thewalters.org/images/art/thumbnails/pl7_371825_fnt_bw-4.jpg",
                    "width": "235",
                    "height": "192"
                }
            },
            {
                "id": "21286",
                "id_string": "panorama-with-the-abduction-of-helen-amidst-the-wonders-of-the-ancient-world",
                "title": "Panorama with the Abduction of Helen Amidst the Wonders of the Ancient World",
                "period": "1535 (Renaissance)",
                "accession": "37.656",
                "tags": [
                    "architecture",
                    "atmospheric",
                    "perspective",
                    "boat",
                    "story",
                    "landscape",
                    "helen",
                    "paris",
                    "slaves",
                    "ruins",
                    "abduction"
                ],
                "thumbnail": {
                    "url": "http://art.thewalters.org/images/art/thumbnails/pl1_37656_fnt_tr_t86ia-2.jpg",
                    "width": "235",
                    "height": "86"
                }
            }
        ]
    }

### Locations
/locations

Ex:

    [
        {
            "id": "ancient-world-lobby",
            "name": "Museum Location: Ancient World Lobby",
            "location": "Centre Street, Second Floor",
            "thumbnail": {
                "url": "http://art.thewalters.org/images/locations/2ndfloorlobby.jpg"
            }
        },
        {
            "id": "egyptian-art",
            "name": "Museum Location: Egyptian Art",
            "location": "Centre Street, Second Floor",
            "thumbnail": {
                "url": "http://art.thewalters.org/images/locations/egyptianart001.jpg"
            }
        }
    ]
/locations/${LOCATION}

Ex: /locations/ancient-world-lobby

    {
        "pieces": [
            {
                "id": "9453",
                "id_string": "amun-min-kamutef",
                "title": "Amun-Min-Kamutef",
                "period": "7th-4th century BC (Late Period)",
                "accession": "54.2062",
                "tags": [
                    "cock",
                    "fucking"
                ],
                "thumbnail": {
                    "url": "http://art.thewalters.org/images/art/thumbnails/pl7_542062_fnt_bw.jpg",
                    "width": "235",
                    "height": "403"
                }
            },
            {
                "id": "8599",
                "id_string": "corner-relief-fragment-with-king-ptolemy-ii-philadelphos-mehyet-and-onuris-shu",
                "title": "Corner Relief Fragment with King Ptolemy II Philadelphos, Mehyet, and Onuris-Shu",
                "period": "285-246 BC (Greco-Roman)",
                "accession": "22.5",
                "thumbnail": {
                    "url": "http://art.thewalters.org/images/art/thumbnails/pl9_225_fnt_bw_c41-2.jpg",
                    "width": "235",
                    "height": "220"
                }
            }
        ],
        "id": "ancient-world-lobby",
        "name": "Museum Location: Ancient World Lobby",
        "location": "Centre Street, Second Floor",
        "thumbnail": {
            "url": "http://art.thewalters.org/images/locations/2ndfloorlobby.jpg"
        }
    }
### Pieces
/pieces

/pieces/${PIECE}

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
