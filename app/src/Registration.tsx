import { FC } from 'react';
import { SubmitHandler, useForm } from "react-hook-form";
import { Grid, Typography } from "@mui/material";
import { useTranslation } from "react-i18next";
import { AppActionType, useAppContext } from "./AppContext";
import AppForm from "./Form";

const RegistrationPanel: FC<{ step: string }> = ({ step }) => {
  const [{ UPN, number, type, action }] = useAppContext();
  const { t } = useTranslation();

  const fields = [
    { label: t('UPN.Label'), value: UPN },
    { label: t('PhoneNumber.Label'), value: number },
  ];

  return (
    <Grid container spacing={2}>
      <Grid item>
        <Typography>
          {t(`${step}.Message`,
            { context: action, type: t(`PhoneType.${type}`) }
          )}
        </Typography>
      </Grid>
      {fields.map(({ label, value }) => (
        <Grid key={label} container item direction="row" spacing={1}>
          <Grid item>
            <Typography>{label}:</Typography>
          </Grid>
          <Grid item sx={{ marginLeft: 'auto' }}>
            <Typography>{value}</Typography>
          </Grid>
        </Grid>
      ))}
    </Grid>
  );
}

export function Confirm() {
  const [, dispatch] = useAppContext();
  const { handleSubmit } = useForm<{}>();
  const { t } = useTranslation();

  const onSubmit: SubmitHandler<{}> = () => {
    dispatch({ type: AppActionType.CONFIRM });
  };
  const handleBack = () => {
    dispatch({ type: AppActionType.BACK });
  };

  return (
    <AppForm onSubmit={handleSubmit(onSubmit)}
      buttons={[
        {
          text: t('Button.Back'),
          props: { variant: 'contained', onClick: handleBack }
        },
        {
          text: t('Button.Confirm'),
          props: { type: 'submit', variant: 'contained', color: 'primary' }
        }
      ]}
    >
      <RegistrationPanel step="Confirm" />
    </AppForm>
  );
}

export function Result() {
  return <RegistrationPanel step="Result" />;
}
