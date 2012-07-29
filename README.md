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
/mediums/${MEDIUM}

### Creators
/creators
/creators/${CREATOR}

### Tags
/tags
/tags/${TAG}

### Locations
/locations
/locations/${LOCATION}

### Pieces
/pieces
/pieces/${PIECE}

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
