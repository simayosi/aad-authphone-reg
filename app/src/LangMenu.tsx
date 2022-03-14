import React, { useState } from 'react';
import { IconButton, Menu, MenuItem } from '@mui/material';
import LanguageIcon from '@mui/icons-material/Language';
import i18n from 'i18next';
import { getLanguages } from './i18n';

export default function LangMenu() {
  const [langMenu, setLangMenu] = useState<null | HTMLElement>(null);

  const handleIconClick = (event: React.MouseEvent<HTMLButtonElement>) => {
    setLangMenu(event.currentTarget);
  };
  const handleMenuClose = () => {
    setLangMenu(null);
  };
  const handleMenuClick = (lng: string) => {
    i18n.changeLanguage(lng);
    setLangMenu(null);
  };
  const languages = getLanguages();

  return (
    <React.Fragment>
      <IconButton sx={{ position: 'absolute', top: 0, right: 0 }}
        onClick={handleIconClick}>
        <LanguageIcon />
      </IconButton>
      <Menu id="lang-menu" anchorEl={langMenu}
        open={Boolean(langMenu)} onClose={handleMenuClose}>
        {languages.map(({ code, text }) => (
          <MenuItem key={code} onClick={() => handleMenuClick(code)}>
            {text}
          </MenuItem>
        ))}
      </Menu>
    </React.Fragment>
  );
}
