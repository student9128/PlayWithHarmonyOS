import { photoAccessHelper } from "@kit.MediaLibraryKit"
import { BusinessError } from "@kit.BasicServicesKit";
import { playFont } from "../../common/Global";
import { HelloModifier, PlayFixedFontStyle, PlayFontStyle } from "../../common/FontStyle";
import { TextModifier, UIUtils } from "@kit.ArkUI";
import { colorPrimary, PlayColor } from "../../common/Theme";
import { httpPost } from "../../http/HttpUtils";
import LogUtils from "../../utils/LogUtils";

@ComponentV2
export struct MePage {
  @Local imgData: string[] = [];
  @Local fontStyle : TextAttribute = UIUtils.makeObserved(new HelloModifier().fontSize(30))

  getImage() {
    try {
      let photoSelectOptions: photoAccessHelper.PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
      photoSelectOptions.maxSelectNumber = 2;
      photoSelectOptions.isOriginalSupported = true
      let photoPicker: photoAccessHelper.PhotoViewPicker = new photoAccessHelper.PhotoViewPicker();
      photoPicker.select(photoSelectOptions).then((result: photoAccessHelper.PhotoSelectResult) => {
        this.imgData = result.photoUris;
        console.log(`result===${JSON.stringify(result)}`)
      })
    } catch (err) {
      let message = (err as BusinessError).message;
      let code = (err as BusinessError).code;
      console.error(`PhotoViewPicker.select failed with. Code: ${code}, message: ${message}`);
    }
  }

  build() {
    Column() {
      Image($r('app.media.icon')).width(100).height(100)
      Button('获取图片').onClick(() => {
        this.getImage();
      })
      Text('12345').fontFamily(playFont)
      Text('12345').fontColor($r('app.color.text_color'))
      Text('12345').attributeModifier(new PlayFontStyle()).fontColor('#2196f3')
      Text('12345你好').attributeModifier(new PlayFixedFontStyle()).fontColor('#F7418F')
      Text('可变自定义字体属性123333').attributeModifier(this.fontStyle as HelloModifier)
      Button('修改字体颜色').onClick(()=>{
        (this.fontStyle as HelloModifier).setFontColor()
      })
      Text('自定义').fontColor(colorPrimary())
      Text('自定义').fontColor(new PlayColor().backgroundColor())
      Button('调用接口').onClick(()=>{
        let url = 'https://www.wanandroid.com/user/login'
        httpPost(url,{"username": "test01", "password": "123456"}).then((value:ESObject)=>{
          LogUtils.printInfo(`response=${JSON.stringify(value)}`)
        })
      })
      Grid() {
        ForEach(this.imgData, (item: string) => {
          GridItem() {
            Image(item).aspectRatio(1)
          }
        })
      }.columnsTemplate('1fr 1fr').aspectRatio(1)
    }.backgroundColor($r('app.color.start_window_background'))
  }
}