___TERMS_OF_SERVICE___
By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.
___INFO___
{
  "type": "TAG",
  "id": "cvt_consentrix_consent_mode",
  "version": 1,
  "securityGroups": [],
  "displayName": "Consentrix Consent Mode",
  "categories": [
    "TAG_MANAGEMENT",
    "PERSONALIZATION"
  ],
  "brand": {
    "id": "brand_consentrix",
    "displayName": "Consentrix"
  },
  "description": "Sets denied Google Consent Mode v2 defaults during Consent Initialization and translates consentrix_consent_update events into native consent-state updates.",
  "containerContexts": [
    "WEB"
  ]
}
___TEMPLATE_PARAMETERS___
[
  {
    "type": "GROUP",
    "name": "commandGroup",
    "displayName": "Consent Command",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "SELECT",
        "name": "command",
        "displayName": "",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "default",
            "displayValue": "Set denied defaults (Consent Initialization - All Pages)"
          },
          {
            "value": "update",
            "displayValue": "Update from consentrix_consent_update"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "default",
        "alwaysInSummary": true,
        "subParams": [],
        "help": "Create one tag instance for denied defaults and one tag instance for Consentrix updates."
      }
    ],
    "help": "The default instance must use Consent Initialization - All Pages. The update instance must use the consentrix_consent_update custom-event trigger."
  },
  {
    "type": "GROUP",
    "name": "defaultGroup",
    "displayName": "Denied Default Settings",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "TEXT",
        "name": "waitForUpdate",
        "displayName": "Wait for Consentrix update (milliseconds)",
        "simpleValueType": true,
        "defaultValue": 500,
        "valueValidators": [
          {
            "type": "POSITIVE_NUMBER"
          }
        ],
        "help": "Allows Consentrix time to restore a saved choice before Google tags proceed. Recommended: 500 ms."
      }
    ],
    "enablingConditions": [
      {
        "paramName": "command",
        "paramValue": "default",
        "type": "EQUALS"
      }
    ],
    "help": "All non-essential Consent Mode v2 signals are denied synchronously. security_storage remains granted."
  },
  {
    "type": "GROUP",
    "name": "updateGroup",
    "displayName": "Consentrix Event Mapping",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "LABEL",
        "name": "automaticMappingLabel",
        "displayName": "No variables are required. This tag reads Consentrix category booleans directly from the consentrix_consent_update data-layer event."
      }
    ],
    "enablingConditions": [
      {
        "paramName": "command",
        "paramValue": "update",
        "type": "EQUALS"
      }
    ],
    "help": "analytics controls analytics_storage; marketing controls ad_storage, ad_user_data, and ad_personalization; functional and personalization control their matching storage signals."
  }
]
___SANDBOXED_JS_FOR_WEB_TEMPLATE___
const setDefaultConsentState = require('setDefaultConsentState');
const updateConsentState = require('updateConsentState');
const copyFromDataLayer = require('copyFromDataLayer');

const asConsentValue = (value) =>
  value === true || value === 'true' || value === 'granted' ? 'granted' : 'denied';

if (data.command === 'default') {
  setDefaultConsentState({
    ad_storage: 'denied',
    analytics_storage: 'denied',
    ad_user_data: 'denied',
    ad_personalization: 'denied',
    functionality_storage: 'denied',
    personalization_storage: 'denied',
    security_storage: 'granted',
    wait_for_update: data.waitForUpdate || 500,
  });
  data.gtmOnSuccess();
  return;
}

if (data.command === 'update') {
  const analytics = asConsentValue(copyFromDataLayer('consentrix_analytics'));
  const marketing = asConsentValue(copyFromDataLayer('consentrix_marketing'));
  const functional = asConsentValue(copyFromDataLayer('consentrix_functional'));
  const personalization = asConsentValue(copyFromDataLayer('consentrix_personalization'));

  updateConsentState({
    ad_storage: marketing,
    analytics_storage: analytics,
    ad_user_data: marketing,
    ad_personalization: marketing,
    functionality_storage: functional,
    personalization_storage: personalization,
    security_storage: 'granted',
  });
  data.gtmOnSuccess();
  return;
}

data.gtmOnFailure();
___WEB_PERMISSIONS___
[
  {
    "instance": {
      "key": {
        "publicId": "access_consent",
        "versionId": "1"
      },
      "param": [
        {
          "key": "consentTypes",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "analytics_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "wait_for_update"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "functionality_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "personalization_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "security_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_user_data"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_personalization"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "consentrix_analytics"
              },
              {
                "type": 1,
                "string": "consentrix_marketing"
              },
              {
                "type": 1,
                "string": "consentrix_functional"
              },
              {
                "type": 1,
                "string": "consentrix_personalization"
              }
            ]
          }
        }
      ]
    }
  }
]
___TESTS___
scenarios:
- name: Sets denied Consent Mode v2 defaults before tags
  code: |-
    runCode({command: 'default', waitForUpdate: 500});
    assertApi('setDefaultConsentState').wasCalledWith({
      ad_storage: 'denied',
      analytics_storage: 'denied',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      functionality_storage: 'denied',
      personalization_storage: 'denied',
      security_storage: 'granted',
      wait_for_update: 500,
    });
    assertApi('gtmOnSuccess').wasCalled();
- name: Maps all Consentrix categories to granted consent
  code: |-
    mock('copyFromDataLayer', (key) => ({
      consentrix_analytics: true,
      consentrix_marketing: true,
      consentrix_functional: true,
      consentrix_personalization: true,
    })[key]);
    runCode({command: 'update'});
    assertApi('updateConsentState').wasCalledWith({
      ad_storage: 'granted',
      analytics_storage: 'granted',
      ad_user_data: 'granted',
      ad_personalization: 'granted',
      functionality_storage: 'granted',
      personalization_storage: 'granted',
      security_storage: 'granted',
    });
    assertApi('gtmOnSuccess').wasCalled();
- name: Maps mixed Consentrix categories independently
  code: |-
    mock('copyFromDataLayer', (key) => ({
      consentrix_analytics: true,
      consentrix_marketing: false,
      consentrix_functional: true,
      consentrix_personalization: false,
    })[key]);
    runCode({command: 'update'});
    assertApi('updateConsentState').wasCalledWith({
      ad_storage: 'denied',
      analytics_storage: 'granted',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      functionality_storage: 'granted',
      personalization_storage: 'denied',
      security_storage: 'granted',
    });
- name: Rejects unsupported commands
  code: |-
    runCode({command: 'unsupported'});
    assertApi('gtmOnFailure').wasCalled();
___NOTES___
Consentrix Consent Mode template v0.51.0.

Installation:
1. Create a default instance and fire it on Consent Initialization - All Pages.
2. Create an update instance and fire it on the custom event consentrix_consent_update.
3. Configure Additional Consent Checks on non-essential tags.

The Consentrix event is a post-consent re-evaluation signal. It is not a firing gate.
