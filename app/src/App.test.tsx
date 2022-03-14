import React from 'react';
import { render, screen } from '@testing-library/react';
import App from './App';

jest.mock('react-i18next', () => ({
  useTranslation: () => ({
    t: (str: string) => str,
  }),
  changeLanguage: () => { },
}));

test('renders the input form', () => {
  render(<App />);
  const urlTextField = screen.getByLabelText('UPN.Label');
  const numberTextField = screen.getByLabelText('PhoneNumber.Label');
  expect(urlTextField).toBeInTheDocument();
  expect(numberTextField).toBeInTheDocument();
});
