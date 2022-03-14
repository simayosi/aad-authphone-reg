import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import Backend from 'i18next-http-backend';
import LanguageDetector from 'i18next-browser-languagedetector';

type Languages = { code: string, text: string }[];

i18n
  .use(Backend)
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    fallbackLng: process.env.REACT_APP_DEFAULT_LANG,
    backend: {
      loadPath: process.env.PUBLIC_URL + '/locales/{{lng}}.json',
    },
    interpolation: {
      escapeValue: false,
    },
  });

i18n.on('languageChanged', (lng) => {
  document.documentElement.lang = lng;
  document.title = i18n.t('Title');
  document.querySelector('meta[name="description"]')
    ?.setAttribute('content', i18n.t('Description'));
});

const langsFetcher = (() => {
  const promise = fetch(process.env.PUBLIC_URL + '/locales/langs.json')
    .then(res => res.json())
    .then(result => { langs = result });
  var langs: undefined | Languages;;
  return {
    get() {
      if (langs) {
        return langs;
      } else {
        throw promise;
      }
    }
  }
})();

export function getLanguages() {
  return langsFetcher.get();
}
