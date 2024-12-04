import { photoAccessHelper } from "@kit.MediaLibraryKit"
import { BusinessError } from "@kit.BasicServicesKit";
import { playFont } from "../../common/Global";
import { PlayFontStyle } from "../../common/FontStyle";

@Component
export struct MePage {
  @State imgData: string[] = [];

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