import axios, { AxiosError, AxiosResponse, AxiosRequestConfig } from '@ohos/axios';
import LogUtils from '../utils/LogUtils';

// export class HttpUtils {
//   requestData = (method, url, body) => {
//     const instance = axios.create({
//       baseURL: 'https://www.wanandroid.com',
//       timeout: 60000,
//       headers: { 'Content-Type': method == 'GET' ? 'application/json' : 'application/x-www-form-urlencoded' }
//     });
//     return new Promise((resolve, reject) => {
//       instance.
//     })
//   }
//
//   get() {
//
//   }
//
//   post() {
//
//   }
// }

const requestData = (method, url, body) => {
  const instance = axios.create({
    baseURL: 'https://www.wanandroid.com',
    timeout: 60000,
    headers: { 'Content-Type': method == 'GET' ? 'application/json' : 'application/x-www-form-urlencoded' }
  });
  // instance.request()
  if (method == 'GET') {
    return new Promise((resolve, reject) => {
      instance.get<string, AxiosResponse<string>>(url, body)
        .then((response: AxiosResponse) => {
          _handleResponse(response, reject, resolve);
        }).catch((err: AxiosError) => {
        reject(err)
        LogUtils.printError(`${JSON.stringify(err)}`)
      })
    })
  } else if (method == 'POST') {
    return new Promise((resolve, reject) => {
      instance.post<string, AxiosResponse<string>>(url, body)
        .then((response: AxiosResponse) => {
          _handleResponse(response, reject, resolve);
        }).catch((err: AxiosError) => {
        reject(err)
        LogUtils.printError(`${JSON.stringify(err)}`)
      })
    })
  }
}

export const httpPost = (url, body) => {
  return requestData("POST", url, body)
}

export const httpGet = (url, body) => {
  return requestData("GET", url, body)
}


function _handleResponse(response: AxiosResponse<any, any>, reject: (reason?: any) => void, resolve: (value: unknown) => void) {
  if (response.status == 200) {
    const res = response.data || {};
    if (res['errorCode'] != 0) {
      reject(res);
      LogUtils.printError(`${JSON.stringify(res)}`);
    } else {
      resolve(res.data);
      LogUtils.printInfo(`${JSON.stringify(res.data)}`);
    }
  } else {
    reject(response.status);
    LogUtils.printError(`${JSON.stringify(response)}`);
  }
}
