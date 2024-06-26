import axios, { AxiosResponse } from '@ohos/axios'
import { httpPost } from '../../http/HttpUtils'
import LogUtils from '../../utils/LogUtils'

@Component
export struct ApiPage {
  build() {
    Column() {
      Button('测试').onClick(() => {
        let url = 'https://www.wanandroid.com/user/login'
        // axios.post<string, AxiosResponse<string>>(url, { "username": "test", "password": "123456" })
        //   .then(value => {
        //     console.log(`value=${JSON.stringify(value)}`)
        //     LogUtils.printInfo(`${JSON.stringify(value)}`)
        // }).catch(error => {
        //   console.log(`error=${error}`)
        // })
        httpPost(url,{ "username": "test01", "password": "123456" }).then((value:ESObject)=>{
          LogUtils.printInfo(`response=${JSON.stringify(value)}`)
        }).catch((error:ESObject)=>{
          LogUtils.printInfo(`error=${JSON.stringify(error)}`)
        });
      })
    }.width('100%')
    .height('100%')

  }
}