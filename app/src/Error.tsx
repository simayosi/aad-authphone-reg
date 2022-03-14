import React, { createContext, FC, useContext } from "react";
import { Box, Typography, Button, Grid } from "@mui/material";
import { useTranslation } from "react-i18next";

interface ErrorInfo {
  type: string;
  detail?: any;
}

export class AppError extends Error {
  info: ErrorInfo;

  constructor(info: ErrorInfo) {
    super(info.type);
    this.name = new.target.name;
    this.info = info;
  }
}

interface ErrorPanelProps {
  error: ErrorInfo;
  clearError: () => void;
}

interface ErrorProps {
  onBack: () => void;
}

type SetError = (error: Error) => void;

interface ErrorState {
  error: ErrorInfo | null;
  setError: SetError;
}

const ErrorContext = createContext<SetError>(() => { });

const ErrorPanel: FC<ErrorPanelProps> = ({ error, clearError }) => {
  const { t } = useTranslation();

  return (
    <Box>
      <Typography variant="body1" paragraph>
        {t(`Error.Message.${error.type}`)}
      </Typography>
      {
        error.detail &&
        <Typography variant="body2" paragraph
          style={{ whiteSpace: "pre-wrap" }}>
          {typeof error.detail === 'string' ?
            error.detail :
            (error.detail.stack ? error.detail.stack : error.detail.message)
          }
        </Typography>
      }
      <Grid container spacing={2} justifyContent="center">
        <Grid item>
          <Button variant="contained" onClick={clearError}>
            {t('Button.Dismiss')}
          </Button>
        </Grid>
      </Grid>
    </Box >
  );
}

class ErrorBoundary extends React.Component<ErrorProps, ErrorState> {
  constructor(props: ErrorProps) {
    super(props);
    this.state = { error: null, setError: this.setError };
  }

  static parseError(error: Error) {
    if (error instanceof AppError) {
      return { error: error.info };
    } else {
      return { error: { type: 'Unknown', detail: error } };
    }
  }
  static getDerivedStateFromError(error: Error) {
    return this.parseError(error);
  }

  setError = (error: Error) => {
    this.setState(ErrorBoundary.parseError(error));
  }

  clearError = () => {
    this.setState({ error: null });
    this.props.onBack();
  };

  render() {
    const { error } = this.state;

    if (error == null) {
      return (
        <ErrorContext.Provider value={this.setError}>
          {this.props.children}
        </ErrorContext.Provider>
      );
    } else {
      return (
        <ErrorPanel error={error} clearError={this.clearError} />
      );
    }
  }
}
export default ErrorBoundary;

export function useSetError() {
  return useContext(ErrorContext);
};
