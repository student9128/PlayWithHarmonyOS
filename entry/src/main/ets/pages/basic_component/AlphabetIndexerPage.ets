import { hSize, wSize } from '../../utils/ScreenUtils'

@Entry
@Component
struct AlphabetIndexerPage {
  @State message: string = 'AlphabetIndexerPage'

  build() {
    Navigation(){
    Row() {
      Column() {
        // Text(this.message)
        //   .fontSize(50)
        //   .fontWeight(FontWeight.Bold)
        Row().width(16).height(20).backgroundColor(Color.Red)
        Row().width(wSize(16)).height(20).backgroundColor(Color.Green)
        Row().width(194).height(20).backgroundColor(Color.Red)
        Row().width(wSize(194)).height(20).backgroundColor(Color.Blue)
        Row().width(wSize(187.5)).height(hSize(20)).backgroundColor(Color.Green)
        Row().width(wSize(375)).height(hSize(20)).backgroundColor(Color.Green)
        Row().width(wSize(750)).height(hSize(20)).backgroundColor(Color.Blue)
        Row().width(375).height(30).backgroundColor(Color.Pink)
        Row().width(387.6).height(30).backgroundColor(Color.Green)
        Row().width('50%').height(30).backgroundColor(Color.Brown)
      }
      .width('100%').height('100%')
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Start)
    }
    .height('100%')
    }.titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
  }
}