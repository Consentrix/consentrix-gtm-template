# Consentrix Google Tag Manager Community Template

The **Consentrix Consent Mode** template provides the native Google Tag Manager consent API bridge for Consentrix. It creates denied Google Consent Mode v2 defaults during GTM’s earliest consent lifecycle event and translates each `consentrix_consent_update` event into a native `updateConsentState` call.

> The `consentrix_consent_update` event is a post-consent state notification. It is not a firing gate. Non-essential tags must still use built-in consent checks, Additional Consent Checks, category-aware conditions, or physical blocking.

## Installation

Import `template.tpl` through **Templates → Tag Templates → New → Import**, review the permission summary, and save the template. Create the following two tag instances.

| Tag | Template command | Trigger | Purpose |
|---|---|---|---|
| Consentrix — Denied Defaults | Set denied defaults | Consent Initialization — All Pages | Denies all non-essential Consent Mode v2 signals before normal tags; grants only `security_storage` and waits 500 ms for a saved choice. |
| Consentrix — Consent Update | Update from `consentrix_consent_update` | Custom Event: `consentrix_consent_update` | Maps Consentrix category booleans to native Consent Mode signals within the same event cycle. |

The update mapping is deterministic and requires no user-defined variables.

| Consentrix event field | Google Consent Mode signal |
|---|---|
| `consentrix_analytics` | `analytics_storage` |
| `consentrix_marketing` | `ad_storage`, `ad_user_data`, `ad_personalization` |
| `consentrix_functional` | `functionality_storage` |
| `consentrix_personalization` | `personalization_storage` |
| Constant | `security_storage=granted` |

## Tag enforcement

For each non-essential tag, configure its required consent types using GTM’s native **Additional Consent Checks**. Consentrix’s GTM audit derives these requirements from vendor/category attribution and verifies the tag’s native consent settings. Adding the update event as another firing trigger does not make a tag compliant because multiple GTM firing triggers are evaluated with OR semantics.

Physical blocking remains appropriate for non-consent-aware third-party scripts and hardcoded scripts outside GTM. Manual markup uses `type="text/plain"` and `data-consentrix-category="analytics|marketing|functional|personalization"`. The runtime-only `data-consentrix-blocked="true"` attribute is applied by Consentrix and is not the manual integration interface.

## Permissions

The template requests only these permissions:

| Permission | Scope |
|---|---|
| Access consent state | The seven Google Consent Mode v2 storage and advertising consent types plus `wait_for_update`. |
| Read data layer | Four exact Consentrix event fields. |

The template does not request network, cookie, global-variable, script-injection, data-layer write, or logging access.

## Validation

The exported template includes sandbox tests for denied defaults, full consent, granular consent, and unsupported commands. Release validation also checks artifact structure, minimal permissions, field mapping, and version alignment. Production browser watchdogs independently verify command ordering, update timing, and duplicate-request prevention.
