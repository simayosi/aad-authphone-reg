import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';
import './i18n'

function supportedBrowser() {
  return (
    Boolean(window.fetch) &&
    typeof Symbol === 'function' && typeof Symbol() === 'symbol'
  );
}

ReactDOM.render(
  <React.StrictMode>
    {
      (supportedBrowser() && <App />)
      || "Your browser is not supported by this app."
    }
  </React.StrictMode>,
  document.getElementById('root')
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
