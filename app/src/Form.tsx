import { FC, FormEventHandler } from "react";
import { Grid, Button, } from "@mui/material";

type FormButtonData = {
  text: string;
  props: any;
}

type AppFormProps = {
  onSubmit?: FormEventHandler<HTMLFormElement>;
  buttons?: FormButtonData[];
};

const AppForm: FC<AppFormProps> = ({ children, onSubmit, buttons }) => {
  return (
    <form onSubmit={onSubmit}>
      {children}
      {buttons &&
        <Grid container spacing={2} justifyContent="flex-end" mt={1}>
          {buttons.map(({ text, props }) => (
            <Grid item key={text}>
              <Button {...props}>{text}</Button>
            </Grid>
          ))}
        </Grid>
      }
    </form >
  );
};
export default AppForm;
