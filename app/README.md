# Frontend application

This frontend applicaiton was bootstrapped
with [Create React App](https://github.com/facebook/create-react-app).

## Build
```shell
yarn build
```
This command builds the frontend application for deployment
to the `build` directory.

You can configure this application at build time
by setting the following environment variables in `.env.local`.

List of environment variables:
- `REACT_APP_API_BASE_URL`: base URL of the REST API endpoints
- `REACT_APP_DEFAULT_LANG`: default language
- `REACT_APP_UPN_PATTERN`: regular expresion for validating the input UPN
- `REACT_APP_NUMBER_PATTERN`: regular expression for validating the input phone number

The default values are defined in `.env`.

## Customizing messages and translations

You can customize the title, descriptions, and messages
by editing JSON files (`<lang-code>.json`) in `public/locales/` before build
or `locales/` on your webserver after deployment.  
To add translations, edit `langs.json` in `locales`.

#### Example to add Traditional Chinese
1. Add Traditional Chinese to the language list in `langs.json` as below.
    ```JSON
    [
      {
        "code": "en",
        "text": "English"
      },
      {
        "code": "ja",
        "text": "日本語"
      },
      {
        "code": "zh-tw",
        "text": "繁體中文"
      }
    ]
    ```
1. Define translated strings in `zh-tw.json`.
