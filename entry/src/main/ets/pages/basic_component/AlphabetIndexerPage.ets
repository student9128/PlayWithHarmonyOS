@Entry
@Component
struct AlphabetIndexerPage {
  @State message: string = 'AlphabetIndexerPage'

  build() {
    Navigation(){
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
    }.titleMode(NavigationTitleMode.Mini)
  }
}