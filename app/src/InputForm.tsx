import { useForm, Controller, SubmitHandler } from 'react-hook-form';
import { TextField } from '@mui/material';
import { useTranslation } from 'react-i18next';
import { AppActionType, useAppContext } from "./AppContext";
import AppForm from './Form';

interface FormData {
  UPN: string;
  number: string;
}

export default function InputForm() {
  const [{ UPN, number }, dispatch] = useAppContext();
  const { handleSubmit, control, formState: { errors } } = useForm<FormData>();
  const { t } = useTranslation();
  const upnPatternRegex =new RegExp(
    process.env.REACT_APP_UPN_PATTERN || '', 'i');
  const numberPatternRegex = new RegExp(
    process.env.REACT_APP_NUMBER_PATTERN || '');

  const onSubmit: SubmitHandler<FormData> = data => {
    dispatch({ type: AppActionType.SET_INPUT, payload: data });
  };

  return (
    <AppForm onSubmit={handleSubmit(onSubmit)}
      buttons={[
        {
          text: t('Button.Submit'),
          props: { type: "submit", variant: "contained", color: "primary" }
        }
      ]}
    >
      <Controller name="UPN" defaultValue={UPN}
        control={control}
        rules={{ required: true, pattern: upnPatternRegex }}
        render={({ field }) =>
          <TextField type="email" id="UPN" label={t('UPN.Label')}
            variant="outlined" fullWidth margin="dense"
            helperText={t('UPN.Desc')} error={!!errors.UPN}
            {...field}
          />
        }
      />

      <Controller name="number" defaultValue={number}
        control={control}
        render={({ field }) =>
          <TextField type="tel" id="number" label={t('PhoneNumber.Label')}
            variant="outlined" fullWidth margin="dense"
            helperText={t('PhoneNumber.Desc')} error={!!errors.number}
            {...field}
          />
        }
        rules={{ required: true, pattern: numberPatternRegex }}
      />
    </AppForm >
  );
}
