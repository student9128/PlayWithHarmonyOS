@ComponentV2
struct CustomAppBar {
  @BuilderParam contentBuilder: () => void
  @Param title: string = ''
  build() {
    Navigation(){
      this.contentBuilder
    }.titleMode(NavigationTitleMode.Mini)
  }
}