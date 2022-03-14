import { createContext, Dispatch, useContext } from "react";

interface AppData {
  UPN: string;
  number: string;
  type: string;
  action: string;
}

export enum AppStep {
  INPUT = 'input',
  CONFIRM = 'confirm',
  FINISH = 'finish'
}
interface AppPhase {
  step: AppStep;
  processing: boolean;
}

export type AppState = AppPhase & AppData;

export enum AppActionType {
  SET_INPUT = 'setUserInput',
  CHECK = 'check',
  BACK = 'back',
  CONFIRM = 'confirm',
  COMMIT = 'commit'
}

type SetInputActionPayload = {
  UPN: string, number: string
};
type SetInputAction = {
  type: AppActionType.SET_INPUT, payload: SetInputActionPayload
};
type CheckActionPayload = {
  type: string, action: string
};
type CheckAction = {
  type: AppActionType.CHECK, payload: CheckActionPayload
};
type ConfirmAction = {
  type: AppActionType.CONFIRM
};
type BackAction = {
  type: AppActionType.BACK
};
type CommitAction = {
  type: AppActionType.COMMIT
};

export type AppAction =
  SetInputAction | CheckAction | ConfirmAction | BackAction | CommitAction;

type AppContextType = [AppState, Dispatch<AppAction>];

const AppContext = createContext<AppContextType>([
  {} as AppState, () => {}
]);
export default AppContext;

export function useAppContext() {
  return useContext(AppContext);
}
