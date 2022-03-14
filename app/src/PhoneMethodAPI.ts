import { FC, useCallback, useEffect } from "react";
import { AppActionType, AppStep, useAppContext } from "./AppContext";
import { AppError, useSetError } from "./Error";

enum APIOperation {
  CHECK = 'check',
  COMMIT = 'commit'
}

interface CheckAPIParam {
  op: APIOperation.CHECK;
  param: { UPN: string };
}
interface CommitAPIParam {
  op: APIOperation.COMMIT;
  param: { UPN: string, number: string, type: string, action: string };
}
type APIRequest = CheckAPIParam | CommitAPIParam;

interface APIResponse {
  UPN?: string;
  number?: string;
  type: string;
  action: string;
}

function postPhoneMethodAPI({ op, param }: APIRequest): Promise<APIResponse> {
  return fetch(process.env.REACT_APP_API_BASE_URL + op, {
    method: 'POST',
    credentials: 'include',
    body: JSON.stringify(param),
  })
    .then(
      response => {
        if (response.ok) {
          return response.json();
        } else {
          return response.text().then(text => {
            let info;
            try {
              info = JSON.parse(text).error;
            } catch (e) {
              info = { type: 'Server_Error', detail: text };
            }
            throw new AppError(info);
          })
        }
      },
      error => {
        throw new AppError({ type: 'Connection_Error', detail: error });
      }
    );
}

export const APICall: FC<{ step: AppStep }> = ({ step }) => {
  const [state, dispatch] = useAppContext();
  const setError = useSetError();

  const createRequest = useCallback((): APIRequest | undefined => {
    const { UPN, number, type, action } = state;
    switch (step) {
      case AppStep.INPUT:
        return {
          op: APIOperation.CHECK,
          param: { UPN: UPN }
        };
      case AppStep.CONFIRM:
        return {
          op: APIOperation.COMMIT,
          param: { UPN: UPN, number: number, type: type, action: action }
        };
      default:
        return undefined;
    }
  }, [step, state]);
  const callAPI = useCallback((req: APIRequest) => {
    postPhoneMethodAPI(req)
      .then(data => {
        switch (req.op) {
          case APIOperation.CHECK:
            dispatch({
              type: AppActionType.CHECK,
              payload: { type: data.type, action: data.action }
            });
            break;
          case APIOperation.COMMIT:
            dispatch({ type: AppActionType.COMMIT });
            break;
        }
      })
      .catch(error => {
        setError(error);
      });
  }, [dispatch, setError]);

  useEffect(() => {
    const req = createRequest();
    if (req) {
      callAPI(req);
    }
  }, [createRequest, callAPI]);

  return null;
}
export default APICall;
