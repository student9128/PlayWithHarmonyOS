@Component
export struct CustomTitleBar {
  @BuilderParam contentBuilder: () => void
  @Prop title: string = ''
  build() {
    Navigation() {
      this.contentBuilder()
    }.titleMode(NavigationTitleMode.Mini)
    .title(this.title)
  }
}