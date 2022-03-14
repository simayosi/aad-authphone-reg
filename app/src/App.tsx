import {
  FC, useContext, useCallback, Reducer, useReducer, Suspense, useMemo
} from "react";
import {
  Paper, Backdrop, CircularProgress, CssBaseline, Container, Typography, Box,
  useMediaQuery
} from '@mui/material';
import { createTheme, styled, ThemeProvider } from '@mui/material/styles';
import { useTranslation } from 'react-i18next';
import AppContext, {
  AppStep, AppActionType, AppState, AppAction
} from "./AppContext";
import LangMenu from './LangMenu';
import ErrorBoundary from "./Error";
import APICall from "./PhoneMethodAPI";
import InputForm from "./InputForm";
import { Confirm, Result } from "./Registration";

const AppPaper = styled(Paper)(({ theme }) => ({
  marginTop: theme.spacing(2),
  marginBottom: theme.spacing(2),
  padding: theme.spacing(1),
  display: 'flex',
  position: 'relative',
  flexDirection: 'column',
  alignItems: 'center',
}));

function AppHeader() {
  const { t } = useTranslation();

  return (
    <Typography component="h1" variant="h5">{t('Title')}</Typography>
  );
}

const StepContent: FC<{ step: AppStep }> = ({ step }) => {
  switch (step) {
    case AppStep.INPUT:
      return <InputForm />;
    case AppStep.CONFIRM:
      return <Confirm />;
    case AppStep.FINISH:
      return <Result />;
  }
}

function AppContent() {
  const [{ step, processing }, dispatch] = useContext(AppContext);
  const onBack = useCallback(() => {
    dispatch({ type: AppActionType.BACK });
  }, [dispatch]);

  return (
    <ErrorBoundary onBack={onBack}>
      {processing && <APICall step={step} />}
      <StepContent step={step} />
      <Backdrop open={processing}
        sx={{ zIndex: (theme) => theme.zIndex.drawer + 1 }} >
        <CircularProgress color="inherit" />
      </Backdrop>
    </ErrorBoundary>
  );
}

const reducer: Reducer<AppState, AppAction> = (state, action) => {
  switch (action.type) {
    case AppActionType.SET_INPUT:
      return { ...state, ...action.payload, processing: true };
    case AppActionType.CHECK:
      return {
        ...state, ...action.payload,
        step: AppStep.CONFIRM, processing: false
      };
    case AppActionType.CONFIRM:
      return { ...state, processing: true };
    case AppActionType.BACK:
      return { ...state, step: AppStep.INPUT, processing: false };
    case AppActionType.COMMIT:
      return { ...state, step: AppStep.FINISH, processing: false };
  }
};

const initialState: AppState = {
  step: AppStep.INPUT, processing: false,
  UPN: '', number: '', type: '', action: ''
};

export default function App() {
  const reduced = useReducer(reducer, initialState);
  const prefersDarkMode = useMediaQuery('(prefers-color-scheme: dark)');
  const theme = useMemo(() =>
    createTheme({
      palette: {
        mode: prefersDarkMode ? 'dark' : 'light',
      },
    }), [prefersDarkMode]);

  return (
    <Suspense fallback="Loading">
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <Container maxWidth="sm">
          <AppPaper>
            <LangMenu />
            <Box component="header" mt={4} mb={1}>
              <AppHeader />
            </Box>
            <Box component="main" mt={2} p={1}>
              <AppContext.Provider value={reduced}>
                <AppContent />
              </AppContext.Provider >
            </Box>
          </AppPaper>
        </Container>
      </ThemeProvider>
    </Suspense>
  );
}
